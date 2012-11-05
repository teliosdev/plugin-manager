require 'plugin_manager/plugin/feature/feature_setup'

module PluginManager

  module Plugin

    # A feature of a plugin, this contains all of the logic of the
    # plugin, such as activerecord callbacks, controller stuff, etc.
    # Think of the plugin as a sort of a bundle, and the feature
    # as the actual item.
    class Feature
      include FeatureSetup
    end
  end
end
