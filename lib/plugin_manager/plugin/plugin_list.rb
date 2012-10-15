module PluginManager

  class Plugin

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
          FEATURES
        end

        # Provide access to PLUGINS
        def []=(name, value)
          PLUGINS[name.to_sym] = value
        end

        # Add a plugin to the list.  Uses the #[]= method to add it.
        # Also initializes the FEATURES key-value pair.
        def add_plugin(name, klass)
          self[name] = klass
          features[name] = Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        # Add a feature to the list.
        def add_feature_for(plugin, name, feature_class)
          raise PluginListError,
            "Class `#{feature_class}' is not a child of `#{Plugin::Feature}'" unless
            feature_class < Plugin::Feature
          features[plugin][name] = feature_class
        end
      end

      # Enables the selected features for the plugin.  +:all+ is
      # replaced with all of the features.
      # It will ignore any features that it cannot find.
      def enable_feature_for(plugin, *raw_features)
        klass = find_plugin! plugin
        _resolve_features(plugin, raw_features).each do |feature|
          self.features[plugin][feature].enable
        end
      end

      # Disables the selected features for the plugin. +:all+ is
      # replaced with all of the features.  It will ignore any
      # features that it cannot find.
      def disable_feature_for(plugin, *raw_features)
        klass = find_plugin! plugin
        _resolve_features(plugin, raw_features).each do |feature|
          self.features[plugin][feature].disable
        end
      end

      protected

      def _resolve_features(plugin, raw_features) #:nodoc:
        raw_features.flatten!
        features = []
        plugin_features = self.features[plugin].keys
        raw_features.each do |f|
          next unless [*plugin_features, :all].include? f
          if f == :all
            features.push *plugin_features
          else
            features << f
          end
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
        end

        # Add a feature to the feature list so that it can be registered
        # properly with the observers.
        def add_feature(name, feature_class, klass=self)
          plugin_name = PluginList.plugin klass
          raise PluginListError,
          "Could not find plugin for class `#{klass}'" unless plugin_name
          PluginList.add_feature_for plugin_name, name, feature_class
        end
      end
    end
  end

  # The plugin did not handle adding itself to the plugin list or
  # adding features to the feature list correctly.
  class PluginListError < StandardError; end
end
