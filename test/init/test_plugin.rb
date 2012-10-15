class TestPlugin < PluginManager::Plugin
  add_plugin :test_plugin

  class Test1 < PluginManager::Plugin::Feature; end
  add_feature :test_1, Test1


end
