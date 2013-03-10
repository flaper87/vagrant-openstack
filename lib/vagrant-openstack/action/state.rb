require "log4r"

module VagrantPlugins
  module ProviderOpenStack
    module Action
      # This action reads the state of the machine and puts it in the
      # `:machine_state_id` key in the environment.
      class State
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::state")
        end

        def call(env)
          env[:machine_state_id] = state(env[:os_connection], env[:machine])

          @app.call(env)
        end

        def state(os, machine)
          return :not_created if machine.id.nil?

          # Find the machine
          server = os.server(machine.id)
          if server.nil?
            # The machine can't be found
            @logger.info("Machine not found or terminated, assuming it got destroyed.")
            machine.id = nil
            return :not_created
          end

          state = server.status.downcase
          return state.to_sym
        end
      end
    end
  end
end
