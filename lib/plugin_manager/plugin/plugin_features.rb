module PluginManager
  class Plugin
    module PluginFeatures

      # The feature list.  This contains all of the plugins and their
      # respective features.
      FEATURES = Hash.new do |hash, key|
        hash[key] = Hash.new { |h, k| h[k] = {} }
      end

      class << self

        def included(klass) #:nodoc:
          klass.send :extend, ClassMethods
        end

        # Easy access to FEATURES.
        def features
          FEATURES
        end

        # Access to the plugin's features
        def plugin_features(plugin)
          FEATURES[plugin]
        end

        # Add a feature to the list.
        def add_feature_for(plugin, name, feature_class)
          raise PluginFeatureError,
            "Class `#{feature_class}' is not a child of `#{Plugin::Feature}'" unless
            feature_class < Plugin::Feature
          features[plugin][name] = feature_class
        end

        # Enables the selected features for the plugin. +:all+ is
        # replaced with all of the features.
        # It will ignore any features that it cannot find.
        def enable_feature_for(plugin, *raw_features)
          klass = PluginList.find_plugin! plugin
          _resolve_features(plugin, raw_features).each do |feature|
            self.features[plugin][feature].enable
          end
        end

        # Disables the selected features for the plugin. +:all+ is
        # replaced with all of the features.  It will ignore any
        # features that it cannot find.
        def disable_feature_for(plugin, *raw_features)
          klass = PluginList.find_plugin! plugin
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

      end

      module ClassMethods
        # Add a feature to the feature list so that it can be registered
        # properly with the observers.
        def add_feature(name, feature_class, klass=self)
          plugin_name = PluginList.plugin klass
          raise PluginFeatureError,
          "Could not find plugin for class `#{klass}'" unless plugin_name
          PluginFeatures.add_feature_for plugin_name, name, feature_class
        end
      end

    end
  end

  class PluginFeatureError < StandardError; end
end
