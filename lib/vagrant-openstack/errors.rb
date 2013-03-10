require "vagrant"

module VagrantPlugins
  module ProviderOpenStack
    module Errors
      class VagrantOpenStackError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_openstack.errors")
      end

      class RsyncError < VagrantOpenStackError
        error_key(:rsync_error)
      end
    end
  end
end
