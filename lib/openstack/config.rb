module VagrantPlugins
  module ProviderOpenStack
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :url

    end
  end
end
