require "fog"
require "log4r"

module VagrantPlugins
  module ProviderOpenStack
    module Action
      class Connect
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::connect")
        end

        def call(env)
          config = env[:machine].provider_config

          @logger.info("Connecting to OpenStack...")
          #env[:os_connection] = OpenStack::Connection.create({
          #                  :username => config.user,
          #                  :api_key => config.password,
          #                  :auth_method => "password",
          #                  :auth_url => config.url,
          #                  :authtenant_name => config.tenant,
          #                  :service_type => "compute"})
        
          env[:os_connection] = Fog::Compute.new({
            :provider => :openstack,
            :openstack_tenant => config.tenant,
            :openstack_api_key => config.password,
            :openstack_auth_url => config.url,
            :openstack_username => config.user,
            :openstack_service_type  => "compute"
          })                 
          @app.call(env)
        end
      end
    end
  end
end
