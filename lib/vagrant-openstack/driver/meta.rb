require "forwardable"

require "log4r"

require File.expand_path("../base", __FILE__)

module VagrantPlugins
  module ProviderOpenStack
    module Driver
      class Meta < Base
        # This is raised if the VM is not found when initializing a driver
        # with a UUID.
        class VMNotFound < StandardError; end

        # We use forwardable to do all our driver forwarding
        extend Forwardable

        # The UUID of the virtual machine we represent
        attr_reader :uuid

        # The version of virtualbox that is running.
        attr_reader :version

        def initialize(uuid=nil)
          # Setup the base
          super()

          @logger = Log4r::Logger.new("vagrant::provider::virtualbox::meta")
          @uuid = uuid


          driver_klass = Folsom
          @logger.info("Using VirtualBox driver: #{driver_klass}")
          @driver = driver_klass.new(@uuid)

        end

        def_delegators :@driver, :clear_forwarded_ports,
          :clear_shared_folders,
          :create_dhcp_server,
          :create_host_only_network,
          :delete,
          :delete_unused_host_only_networks,
          :discard_saved_state,
          :enable_adapters,
          :execute_command,
          :export,
          :forward_ports,
          :halt,
          :import,
          :read_forwarded_ports,
          :read_bridged_interfaces,
          :read_guest_additions_version,
          :read_host_only_interfaces,
          :read_mac_address,
          :read_mac_addresses,
          :read_machine_folder,
          :read_network_interfaces,
          :read_state,
          :read_used_ports,
          :read_vms,
          :resume,
          :set_mac_address,
          :set_name,
          :share_folders,
          :ssh_port,
          :start,
          :suspend,
          :verify!,
          :verify_image,
          :vm_exists?

        protected

      end
    end
  end
end
