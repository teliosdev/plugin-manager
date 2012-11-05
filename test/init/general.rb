require File.absolute_path('../../../lib/plugin_manager', __FILE__)

class Plugin1
  include PluginManager::Plugin
  add_plugin :plugin_1
  class Feature1 < PluginManager::Plugin::Feature
    add_enable_hook :up
    add_disable_hook :down

    def up
      puts "Hello, World!"
    end

    def down
      puts "Goodbye, World!"
    end
  end
  add_feature :feature_1
end
