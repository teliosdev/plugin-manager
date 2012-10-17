module PluginManager
  module Plugin
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
          unless feature_class
            # Make sure that no matter what, the plugin is correct in its path to the feature;
            # i.e., if there is a plugin called +:my_plugin+ of class My::Plugin, this will
            # correctly reference +My::Plugin+, not +MyPlugin+.
            feature_class = "#{PluginList[plugin]}::#{name.to_s.camelize}".constantize
          end
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
        def add_feature(name, feature_class=nil, klass=self)
          plugin_name = PluginList.plugin! klass
          PluginFeatures.add_feature_for plugin_name, name, feature_class
        end

        # Enables a feature for the class.
        def enable_feature(*features)
          plugin_name = PluginList.plugin! self
          PluginFeatures.enable_feature_for plugin_name, *features
        end

        alias_method :enable_features, :enable_feature

        # Disables a feature for the class.
        def disable_feature(*features)
          plugin_name = PluginList.plugin! self
          PluginFeatures.disable_feature_for plugin_name, *features
        end

        alias_method :disable_features, :disable_feature

      end

    end
  end

  class PluginFeatureError < StandardError; end
end
