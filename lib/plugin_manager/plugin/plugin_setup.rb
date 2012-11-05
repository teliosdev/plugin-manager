module PluginManager

  module Plugin

    # This just provides methods that are somewhat helpful to the
    # actual plugin; it doesn't provide any functionality, but rather
    # methods that may or may not be helpful.
    module PluginSetup

      def self.included(klass) #:nodoc:
        klass.send :extend, ClassMethods
      end

      module ClassMethods

        # Enables all of the features of this plugin.  It skips over
        # the features that are already enabled.  Can be called even
        # though all of the features are enabled, resulting in
        # absolutely nothing happening.  Good going.
        def enable
          enable_features :all
        end

        # Disables all of the features of the plugin.  Skips over
        # plugins that are already disabled.
        def disable
          disable_features :all
        end

        # This determines whether or not the plugin is diabled.
        def enabled?
          enabled = false
          features.each do |f|
            enabled = true if f.enabled?
          end
          enabled
        end
      end
    end
  end
end
