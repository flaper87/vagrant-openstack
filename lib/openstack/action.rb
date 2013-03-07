require "vagrant/action/builder"

module VagrantPlugins
  module ProviderOpenStack
    module Action

      autoload :EnsureCreated, File.expand_path("../action/create", __FILE__)
      # Include the built-in modules so that we can use them as top-level
      # things.
      include Vagrant::Action::Builtin

      # This action brings the machine up from nothing, including importing
      # the box, configuring metadata, and booting.
      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, EnsureCreated do |env, b2|
          end
        end
      end
    end
  end
end
