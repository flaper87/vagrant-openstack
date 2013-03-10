module VagrantPlugins
  module ProviderOpenStack
    module Action
      class Boot
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::boot")
        end

        def call(env)
          config = env[:machine].provider_config
          os = env[:os_connection]
          if !env[:machine].id
            @logger.info("Attempting to boot a new VM")
            server = os.create_server({
                    :imageRef => config.image, 
                    :flavorRef => config.flavor, 
                    :key_name => config.keypair, 
                    :name=>config.name})
            env[:machine].id = server.id
            env[:ui].warn(I18n.t("vagrant_openstack.vm_booted",
                                :id => server.id,
                                :name => server.name))
          end
          @app.call(env)
        end
      end
    end
  end
end
