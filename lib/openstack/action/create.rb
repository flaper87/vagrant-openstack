module VagrantPlugins
  module ProviderOpenStack
    module Action
      class EnsureCreated
        def initialize(app, env)
          @app = app
        end

        def call(env)
        @app.call(env)
        end
      end
    end
  end
end
