require "log4r"

module VagrantPlugins
  module ProviderOpenStack
    module Action
      # This action reads the state of the machine and puts it in the
      # `:machine_state_id` key in the environment.
      class Delete
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::delete")
        end

        def call(env)
          os = env[:os_connection]
          server = os.server(env[:machine].id)

          env[:ui].info(I18n.t("vagrant_openstack.deleting"))
          server.delete!
          env[:machine].id = nil

          @app.call(env)
        end
      end
    end
  end
end

