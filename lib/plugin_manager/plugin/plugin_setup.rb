require 'plugin_manager/plugin/plugin_setup/enable'

module PluginManager

  class Plugin

    # This isn't actually a part of the plugin manager anymore.  This
    # was the old way of enabling/disabling plugins, and was going to
    # cloud up the namespace of the actual classes.  The new method
    # should be much better, because it uses an outside observer for
    # one, a new set of controllers for two, and something else.
    class PluginSetup #:nodoc:

      def self.included(klass) #:nodoc:
        klass.send :extend, ClassMethods
      end

      module ClassMethods

        # old description of +enable+.
        # Enables the plugin.  First, it checks if the method +init+
        # exists.  If it does, it runs it with the PluginSetup::Enable
        # as the argument.  If +init+ does not exist, it checks
        # for +up+; if this does not exist either, it raises a
        # PluginEnableError.  Does not do anything if the plugin is
        # enabled.

        # I don't know anymore.
        def enable
          return if @_enabled
          #raise PluginEnableError,
          #  "Method `init' does not exist for class #{self}" unless
          #  respond_to? :init

          @_enabled = true
        end

        # Disables the plugin.  It checks if +init+ exists, and if it
        # does, it runs with the PluginSetup::Disable as the argument.
        # If +init+ does not exist, it checks for +down+; if this does
        # not exist, it raises a PluginDisableError.  Does not do
        # anything if the plugin is not enabled.
        def disable
          return unless @_enabled
          if respond_to? :init
            send :init, PluginSetup::Disable
          elsif respond_to? :down
            send :down, PluginSetup::Disable
          end
          @_enabled = false
        end

        # This determines whether or not the plugin is diabled.  It uses
        # the +@_enabled+ class variable.
        def enabled?
          @_enabled
        end
      end

      # For some reason, the plugin could not be enabled.  The reason
      # is passed as a string.
      class PluginEnableError < StandardError; end

      # For some reason, the plugin could not be disabled.  The reason
      # is passed as a string.
      class PluginDisableError < StandardError; end
    end
  end
end
