lib_dir = File.absolute_path('../', __FILE__)
$: << lib_dir unless $:.include? lib_dir

require 'active_support/inflector'
require 'plugin_manager/plugin'
#require 'plugin_manager/database_interface'

# PluginManager is a manager for plugins for Rails.  It allows for
# enabling/disabing plugins internally, without requiring a restart.
# It also handles plugin configuration, feature configuration,
# feature disabling/enabling, and many other things.
module PluginManager

end
