require "vagrant/action/builder"

module VagrantPlugins
  module ProviderOpenStack
    module Action

      autoload :Boot, File.expand_path("../action/boot", __FILE__)
      autoload :State, File.expand_path("../action/state", __FILE__)
      autoload :Delete, File.expand_path("../action/delete", __FILE__)
      autoload :Connect, File.expand_path("../action/connect", __FILE__)
      autoload :Created, File.expand_path("../action/created", __FILE__)
      autoload :SyncFolders, File.expand_path("../action/sync_folder", __FILE__)
      autoload :ReadSSHInfo, File.expand_path("../action/read_ssh_info", __FILE__)
      autoload :ReleaseIp, File.expand_path("../action/release_ip", __FILE__)
      # Include the built-in modules so that we can use them as top-level
      # things.
      include Vagrant::Action::Builtin
      
      # This action is called when `vagrant provision` is called.
      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, Created do |env, b2|
            if !env[:result]
              b2.use MessageNotCreated
              next
            end

            b2.use Provision
            b2.use SyncFolders
          end
        end
      end

      # This action is called to terminate the remote machine.
      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Connect
          b.use ReleaseIp
          b.use Delete
        end
      end

      # This action is called to read the state of the machine. The
      # resulting state is expected to be put into the `:machine_state_id`
      # key.
      def self.action_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Connect
          b.use State
        end
      end

      # This action is called to read the SSH info of the machine. The
      # resulting state is expected to be put into the `:machine_ssh_info`
      # key.
      def self.action_read_ssh_info
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Connect
          b.use ReadSSHInfo
        end
      end

      # This action is called to SSH into the machine.
      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, Created do |env, b2|
            if !env[:result]
              #b2.use MessageNotCreated
              next
            end

            b2.use SSHExec
          end
        end
      end

      # This action brings the machine up from nothing, including importing
      # the box, configuring metadata, and booting.
      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Connect
          b.use Call, Created do |env, b2|
            if env[:result]
                #b2.use MessageAlreadyCreated
                next
            end
            b2.use Boot
            b2.use SyncFolders
          end
        end
      end
    end
  end
end
