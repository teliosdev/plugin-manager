require 'feature_plugin'
require 'feature_callbacks'

class TestFeatureHooks < Test::Unit::TestCase

  test "adds hooks to list" do
    assert_equal Feature1.instance_variable_get(:@_enable_hooks), [:run]
  end

  test "runs hooks" do
    assert_nothing_raised do
      PluginManager::Plugin::PluginFeatures.enable_feature_for :feature_plugin, :feature_1
    end
    assert Feature1.instance_variable_get(:@run_called)
  end

  test "callbacks can run" do
    setup_feature_callbacks
    assert $run_edit_run
  end

  test "callbacks are removed" do
    setup_feature_callbacks
    $run_edit_run = false
    assert_nothing_raised do
      PluginManager::Plugin::PluginFeatures.disable_feature_for :feature_callbacks, :feature_2
      PluginManager::FeatureInterface.run_callback TestClass, :edit
    end
    assert !$run_edit_run
  end

  def setup_feature_callbacks
    assert_nothing_raised do
      PluginManager::Plugin::PluginFeatures.enable_feature_for :feature_callbacks, :feature_2
      PluginManager::FeatureInterface.run_callback TestClass, :edit
    end
  end


end
