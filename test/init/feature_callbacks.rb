class TestClass; end

class FeatureCallbacks < PluginManager::Plugin
  add_plugin :feature_callbacks

  class Feature2 < PluginManager::Plugin::Feature
    class << self
      def init
        add_callback :edit, TestClass, :run_edit
      end

      def run_edit
        $run_edit_run = true
      end
    end

  end

  add_feature :feature_2, Feature2
end
