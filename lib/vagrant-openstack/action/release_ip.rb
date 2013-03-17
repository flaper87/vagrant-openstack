require "log4r"

module VagrantPlugins
  module ProviderOpenStack
    module Action
      # This action reads the SSH info for the machine and puts it into the
      # `:machine_ssh_info` key in the environment.
      class ReleaseIp
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::read_ssh_info")
        end

        def call(env)
          os = env[:os_connection]
          config = env[:machine].provider_config

          # Find the machine
          server = os.servers.get(env[:machine].id)
          if server.nil?
            # The machine can't be found
            @logger.info("Machine couldn't be found, assuming it got destroyed.")
            machine.id = nil
            return nil
          end

          ips = os.list_all_addresses.body["floating_ips"]
                     .select{|data| data['instance_id'] == server.id}

          ips.each do |ip|
              # Do not release the ip if it was explicitly
              # specified by the user.
              if not ip["ip"] == config.floating_ip
                os.release_address(ip["id"])
              end
          end

          @app.call(env)
        end
      end
    end
  end
end
