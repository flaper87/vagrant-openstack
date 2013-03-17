require "log4r"

module VagrantPlugins
  module ProviderOpenStack
    module Action
      # This action reads the SSH info for the machine and puts it into the
      # `:machine_ssh_info` key in the environment.
      class ReadSSHInfo
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::read_ssh_info")
        end

        def call(env)
          env[:machine_ssh_info] = read_ssh_info(env[:os_connection], env[:machine])

          @app.call(env)
        end

        def read_ssh_info(os, machine)
          return nil if machine.id.nil?

          # Find the machine
          server = os.servers.get(machine.id)
          if server.nil?
            # The machine can't be found
            @logger.info("Machine couldn't be found, assuming it got destroyed.")
            machine.id = nil
            return nil
          end

          config = machine.provider_config
          ssh_info = {
            :host => get_ip(os, server.id),
            :port => 22,
            :username => config.ssh_username,
          }

          if config.ssh_private_key
              ssh_info[:private_key_path] = config.ssh_private_key
          end
          
          return ssh_info
        end

        def get_ip(os, id)
            return os.list_all_addresses.body["floating_ips"]
                     .select{|data| data['instance_id'] == id}
                     .map{|addr| addr["ip"]}.first
        end
      end
    end
  end
end
