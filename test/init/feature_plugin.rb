class Feature1 < PluginManager::Plugin::Feature

  add_enable_hook :run

  private

  def self.run
    @run_called = true
  end
end

class FeaturePlugin < PluginManager::Plugin
  add_plugin :feature_plugin

  add_feature :feature_1, Feature1

end
