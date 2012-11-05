require 'plugin_manager/plugin/feature'
require 'plugin_manager/plugin/plugin_list'
require 'plugin_manager/plugin/plugin_features'
require 'plugin_manager/plugin/plugin_setup'
#require 'plugin_manager/plugin/rails_engine' if defined? ::Rails
#require 'plugin_manager/plugin/plugin_setup'

#
module PluginManager

  ##
  # The Plugin class is the class that is expected to be extended by
  # all plugins that are a part of the plugin management system; when
  # a plugin extends this class, it is expected to call +add_plugin+
  # to add it to the plugin managment system.
  module Plugin
    include PluginList
    include PluginFeatures
    include PluginSetup
    #include RailsEngine if defined? ::Rails

    def self.included(base)
      base.send :include, PluginList
      base.send :include, PluginFeatures
      base.send :include, PluginSetup
      #base.send :include, RailsEngine if defined? ::Rails
    end
  end
end
