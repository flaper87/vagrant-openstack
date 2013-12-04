require "fog"
require "log4r"

require 'vagrant/util/retryable'

module VagrantPlugins
  module ProviderOpenStack
    module Action
      # This creates the openstack server.
      class Boot
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::create_server")
        end

        def call(env)
          # Get the configs
          config   = env[:machine].provider_config

          # Find the flavor
          env[:ui].info(I18n.t("vagrant_openstack.finding_flavor"))
          flavor = find_matching(env[:os_connection].flavors.all, config.flavor)
          raise Errors::NoMatchingFlavor if !flavor

          # Find the image
          env[:ui].info(I18n.t("vagrant_openstack.finding_image"))
          images = env[:os_connection].images.all
          if images.nil? || images.empty?
            image = env[:os_connection].images.get(config.image)
          else
            image = find_matching(env[:os_connection].images.all, config.image)
          end
          raise Errors::NoMatchingImage if !image

          # Figure out the name for the server
          server_name = config.name || env[:machine].name

          # If we're using the default keypair, then show a warning
          default_key_path = Vagrant.source_root.join("keys/vagrant.pub").to_s
          public_key_path  = File.expand_path(config.public_key_path, env[:root_path])

          if default_key_path == public_key_path
            env[:ui].warn(I18n.t("vagrant_openstack.warn_insecure_ssh"))
          end

          # Output the settings we're going to use to the user
          env[:ui].info(I18n.t("vagrant_openstack.launching_server"))
          env[:ui].info(" -- Flavor: #{flavor.name}")
          env[:ui].info(" -- Image: #{image.name}")
          env[:ui].info(" -- Name: #{server_name}")

          # Build the options for launching...
          options = {
            :flavor_ref   => flavor.id,
            :image_ref    => image.id,
            :name        => server_name,
            }

          if not config.security_groups.nil? and not config.security_groups.empty? then
              options.store(:security_groups, config.security_groups)
          end

          if not config.keypair.nil?
              options.store(:key_name, config.keypair)
          else
              options.store(:personality, [
              {
                :path     => "/root/.ssh/authorized_keys",
                :contents => IO.read(public_key_path)
              }
            ])
          end
          # Create the server
          begin
              server = env[:os_connection].servers.create(options)
          rescue Excon::Errors::BadRequest => e
              message = JSON.parse(e.response.body)["badRequest"]["message"]
              raise Excon::Errors::BadRequest, "Error creating server, Openstack returned message: #{message}" 
          end

          # Store the ID right away so we can track it
          env[:machine].id = server.id

          # Wait for the server to finish building
          env[:ui].info(I18n.t("vagrant_openstack.waiting_for_build"))
          retryable(:on => Fog::Errors::TimeoutError, :tries => 200) do
            # If we're interrupted don't worry about waiting
            next if env[:interrupted]

            # Set the progress
            env[:ui].clear_line
            env[:ui].report_progress(server.progress, 100, false)

            # Wait for the server to be ready
            begin
              server.wait_for(5) { ready? }
            rescue RuntimeError => e
              # If we don't have an error about a state transition, then
              # we just move on.
              raise if e.message !~ /should have transitioned/
              raise Errors::CreateBadState, :state => server.state
            end
          end

          if !env[:interrupted]
            # Clear the line one more time so the progress is removed
            env[:ui].clear_line

            floating_ip = config.floating_ip
            if floating_ip.nil?
                begin
                    floating_ip = env[:os_connection].allocate_address.body["floating_ip"]["ip"]
                rescue Excon::Errors::RequestEntityTooLarge => e
                    message = JSON.parse(e.response.body)["overLimit"]["message"]
                    raise Excon::Errors::RequestEntityTooLarge, "Error allocating ip, Openstack returned message: #{message}" 
                end
            end

            env[:ui].info(I18n.t("vagrant_openstack.associating_ip",
                                :ip => floating_ip,
                                :id => server.id))

            env[:os_connection].associate_address(server.id, floating_ip)

            # Wait for SSH to become available
            env[:ui].info(I18n.t("vagrant_openstack.waiting_for_ssh"))
            while true
              # If we're interrupted then just back out
              break if env[:interrupted]
              break if env[:machine].communicate.ready?
              sleep 2
            end

            env[:ui].info(I18n.t("vagrant_openstack.ready"))
          end

          @app.call(env)
        end

        protected

        # This method finds a matching _thing_ in a collection of
        # _things_. This works matching if the ID or NAME equals to
        # `name`. Or, if `name` is a regexp, a partial match is chosen
        # as well.
        def find_matching(collection, name)
          collection.each do |single|
            return single if single.id == name
            return single if single.name == name
            return single if name.is_a?(Regexp) && name =~ single.name
          end

          nil
        end
      end
    end
  end
end
