module PluginManager

  module Plugin

    # Keeps track of Plugins and Features in a list, for easy access
    # to each and every plugin/feature.
    module PluginList

      # The plugin list.  Rather, a hash; the keys are always symbols
      # and the values are always classes.
      PLUGINS = {}

      # The feature list.  This contains all of the plugins and their
      # respective features.
      FEATURES = Hash.new do |hash, key|
        hash[key] = Hash.new { |h, k| h[k] = {} }
      end

      class << self

        # Reset the plugin list by calling +clear+ on it.
        def reset
          PLUGINS.clear
        end

        def included(klass) #:nodoc:
          klass.send :extend, ClassMethods
        end

        # Checks if the +klass+ plugin is in the plugin list. If +klass+
        # is anything but a class, it is checked against the keys of
        # PLUGINS.  If it is a class, it is checked against the values.
        def plugin?(klass)
          case klass
          when Class
            PLUGINS.has_value? klass
          else
            !!PLUGINS[klass.to_sym]
          end
        end

        # Find a plugin by its class.
        def plugin(klass)
          PLUGINS.key klass
        end

        # Find a plugin by its class; if it can't find it, it raises
        # a +PluginListError+ exception.
        def plugin!(klass)
          p = plugin klass
          raise PluginListError,
            "Could not find plugin by class `#{klass}'" unless p
          p
        end

        # Find a plugin given its name.  If it can't be found, it
        # raises a PluginListError.  Otherwise, it returns the class.
        def find_plugin!(name)
          p = self[name]
          raise PluginListError,
            "Could not find plugin by name `#{name}'" unless p
          p
        end

        # Provide access to PLUGINS
        def [](name)
          PLUGINS[name.to_sym]
        end

        # Provides access to the features.
        def features
          PluginFeatures.features
        end

        # Provide access to PLUGINS
        def []=(name, value)
          PLUGINS[name.to_sym] = value
        end

        # Add a plugin to the list.  Uses the #[]= method to add it.
        # Also initializes the FEATURES key-value pair.
        def add_plugin(name, klass)
          self[name] = klass
        end

      end

      # Methods to add to the PluginManager::Plugin class as class
      # methods.
      module ClassMethods

        # Checks if this class is a plugin.  Returns true if it is,
        # false if it isn't.  It is gaurenteed to return either of
        # these values.
        def plugin?
          PluginList.plugin? self
        end

        protected

        # Add the plugin to the plugin list so that it can be enabled
        # or disabled, or whatever needs to be done to it.  It
        # automatically sets the plugin's class to itself.
        def add_plugin(name, klass=self)
          PluginList.add_plugin name, klass
          @_plugin_name = name if klass == self
        end
      end
    end
  end

  # The plugin did not handle adding itself to the plugin list or
  # adding features to the feature list correctly.
  class PluginListError < StandardError; end
end
