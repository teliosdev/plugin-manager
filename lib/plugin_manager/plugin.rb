require 'plugin_manager/plugin/plugin_list'

module PluginManager

  ##
  # The Plugin class is the class that is expected to be extended by
  # all plugins that are a part of the plugin management system; when
  # a plugin extends this class, it is expected to call +add_plugin+
  # to add it to the plugin managment system.
  class Plugin
    extend PluginList::ClassMethods
  end
end
