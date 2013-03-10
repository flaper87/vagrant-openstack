module VagrantPlugins
  module ProviderOpenStack
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :url
      attr_accessor :tenant
      attr_accessor :user
      attr_accessor :password


      attr_accessor :name
      attr_accessor :image
      attr_accessor :flavor
      attr_accessor :keypair
      

      attr_accessor :ssh_port
      attr_accessor :ssh_username
      attr_accessor :ssh_private_key

      def initialize()

        # OpenStack related parameters
        @url               = UNSET_VALUE
        @user              = UNSET_VALUE
        @tenant            = UNSET_VALUE
        @password          = UNSET_VALUE


        # Nova / Instance related
        # parameters
        @name          = UNSET_VALUE
        @image         = UNSET_VALUE
        @flavor        = UNSET_VALUE
        @keypair       = UNSET_VALUE


        # Instance access related
        # parameters
        @ssh_port        = 22
        @ssh_username    = UNSET_VALUE

        # Default to current's user id_rsa
        # if it exists in the standard path
        users_key = File.expand_path("~/.ssh/id_rsa")
        @ssh_private_key = (File.exist?(users_key) && users_key) || UNSET_VALUE
      end
    end
  end
end
