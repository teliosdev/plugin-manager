module PluginManager

  class PluginList

    # The plugin list.  Rather, a hash; the keys are always symbols
    # and the values are always classes.
    PLUGINS = {}

    class << self

      # Reset the plugin list by calling +clear+ on it.
      def reset
        PLUGINS.clear
      end

      # Checks if the +name+ plugin is in the plugin list.
      def plugin?(name)
        if PLUGINS[name.to_sym]
          true
        else
          false
        end
      end

      # Provide access to PLUGINS
      def [](name)
        PLUGINS[name.to_sym]
      end

      # Provide access to PLUGINS
      def []=(name, value)
        PLUGINS[name.to_sym] = value
      end
    end

    module ClassMethods

      protected

      # Add the plugin to the plugin list so that it can be enabled
      # or disabled, or whatever needs to be done to it.
      def add_plugin(name)
        PLUGINS[name.to_sym] = self
      end

      def plugin?
        PLUGINS.values.include? self
      end
    end
  end
end
