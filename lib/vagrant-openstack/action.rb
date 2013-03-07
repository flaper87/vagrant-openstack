require "vagrant/action/builder"

module VagrantPlugins
  module ProviderOpenStack
    module Action

      autoload :Boot, File.expand_path("../action/boot", __FILE__)
      autoload :Created, File.expand_path("../action/created", __FILE__)
      # Include the built-in modules so that we can use them as top-level
      # things.
      include Vagrant::Action::Builtin

      # This action brings the machine up from nothing, including importing
      # the box, configuring metadata, and booting.
      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          #b.use ConfigValidate
          b.use Call, Created do |env, b2|
              if !env[:result]
                  b2.use Boot
              end
          end
        end
      end
    end
  end
end
