module VagrantPlugins
  module ProviderOpenStack
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :url
      attr_accessor :vm
      attr_accessor :tenant
      attr_accessor :user
      attr_accessor :password


      attr_accessor :key
      attr_accessor :image
      attr_accessor :flavor
      

    end
  end
end
