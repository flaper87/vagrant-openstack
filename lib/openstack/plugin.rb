require "vagrant"

module VagrantPlugins
  module ProviderOpenStack
    class Plugin < Vagrant.plugin("2")
      name "OpenStack provider"
      description <<-EOF
      The OpenStack provider allows Vagrant to manage and control
      OpenStack virtual machines.
      EOF

      provider(:openstack) do
        require File.expand_path("../provider", __FILE__)
        Provider
      end

      config(:openstack, :provider) do
        require File.expand_path("../config", __FILE__)
        Config
      end
    end

    autoload :Action, File.expand_path("../action", __FILE__)

    # Drop some autoloads in here to optimize the performance of loading
    # our drivers only when they are needed.
    module Driver
      autoload :Meta, File.expand_path("../driver/meta", __FILE__)
      autoload :Folsom, File.expand_path("../driver/folsom", __FILE__)
    end

    #module Model
    #  autoload :ForwardedPort, File.expand_path("../model/forwarded_port", __FILE__)
    #end

    #module Util
    #  autoload :CompileForwardedPorts, File.expand_path("../util/compile_forwarded_ports", __FILE__)
    #end
  end
end
