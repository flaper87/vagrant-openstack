module VagrantPlugins
  module ProviderOpenStack
    module Action
      class Boot
        def initialize(app, env)
          @app = app
        end

        def call(env)
            config = env[:machine].provider_config
            provider = env[:machine].provider
            os = provider.connect(config)
            if !env[:machine].id
                puts os.server("85fc2b46-83e3-4845-bd27-f153b496e398")
                server = os.create_server({
                    :imageRef => config.image, 
                    :flavorRef => config.flavor, 
                    :key_name => config.key, 
                    :name=>config.name})
                env[:machine].id = server.id
                puts env[:machine].id
            end
            @app.call(env)
        end
      end
    end
  end
end
