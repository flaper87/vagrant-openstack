require "i18n"
require "vagrant"

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
      attr_accessor :security_groups
      
      attr_accessor :floating_ip

      attr_accessor :ssh_port
      attr_accessor :ssh_username
      attr_accessor :public_key_path
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
        @keypair       = nil
        @security_groups       = []


        @floating_ip   = nil

        # Instance access related
        # parameters
        @ssh_port        = 22
        @ssh_username    = UNSET_VALUE

        # Default to current's user id_rsa
        # if it exists in the standard path
        pub_users_key = File.expand_path("~/.ssh/id_rsa.pub")
        @public_key_path = (File.exist?(pub_users_key) && pub_users_key) || UNSET_VALUE

        priv_users_key = File.expand_path("~/.ssh/id_rsa")
        @ssh_private_key = (File.exist?(priv_users_key) && priv_users_key) || UNSET_VALUE
      end

      def finalize!
        @url             = nil if @url == UNSET_VALUE
        @user            = nil if @user == UNSET_VALUE
        @tenant          = nil if @tenant == UNSET_VALUE
        @password        = nil if @password == UNSET_VALUE
        @name            = nil if @name == UNSET_VALUE
        @image           = nil if @image == UNSET_VALUE
        @flavor          = nil if @flavor == UNSET_VALUE
        @keypair         = nil if @keypair == UNSET_VALUE
        @security_groups = nil if @security_groups == UNSET_VALUE
        @floating_ip     = nil if @floating_ip == UNSET_VALUE
        @ssh_port        = nil if @ssh_port == UNSET_VALUE
      end

      def validate(machine)
        if @url == nil or @user == nil or @tenant == nil
          return { "config" => [I18n.t("vagrant_openstack.errors.config.openstack")] }
        end

        {}
      end
    end
  end
end
