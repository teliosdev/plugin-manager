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

        # Add a feature to the list.  If no class is given, it tries
        # to guess the class based on the plugin and the name of the
        # feature.
        def add_feature_for(plugin, name, feature_class=nil)
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
          PluginList.find_plugin! plugin
          _resolve_features(plugin, raw_features).each do |feature|
            f = self.features[plugin][feature]
            next if f.enabled?
            f.enable
          end
        end

        # Disables the selected features for the plugin. +:all+ is
        # replaced with all of the features.  It will ignore any
        # features that it cannot find.
        def disable_feature_for(plugin, *raw_features)
          PluginList.find_plugin! plugin
          _resolve_features(plugin, raw_features).each do |feature|
            f = self.features[plugin][feature]
            next unless f.enabled?
            f.disable
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
          features
        end

      end

      module ClassMethods
        # Add a feature to the feature list so that it can be registered
        # properly with the observers.
        def add_feature(name, feature_class=nil, klass=self)
          PluginFeatures.add_feature_for @_plugin_name, name, feature_class
        end

        # Enables a feature for the class.
        def enable_feature(*features)
          PluginFeatures.enable_feature_for @_plugin_name, *features
        end

        alias_method :enable_features, :enable_feature

        # Disables a feature for the class.
        def disable_feature(*features)
          PluginFeatures.disable_feature_for @_plugin_name, *features
        end

        alias_method :disable_features, :disable_feature

        # Returns a list of all of the plugin's features.  This is an
        # array of the classes themselves; not the names of the
        # features.
        def features
          PluginFeatures.plugin_features(@_plugin_name).values
        end

        # Checks to see if a feature is enabled or not.
        def enabled_feature?(feature)
          PluginFeature.plugin_features(@_plugin_name)[feature].enabled?
        end

      end

    end
  end

  class PluginFeatureError < StandardError; end
end
