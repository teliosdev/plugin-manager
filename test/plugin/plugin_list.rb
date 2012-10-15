require 'test_plugin'

class TestPluginList < Test::Unit::TestCase

  def setup
    @plugin_list = PluginManager::Plugin::PluginList
  end

  test "added to plugin list" do
    assert_not_same @plugin_list[:test_plugin], nil
    assert_same     @plugin_list[:test_plugin], @plugin_list::PLUGINS[:test_plugin]
    assert_same     @plugin_list[:test_plugin], TestPlugin
  end

  test "plugin returns true" do
    assert @plugin_list.plugin? TestPlugin
    assert @plugin_list.plugin? :test_plugin
    assert TestPlugin.plugin?
  end

  test "should not add methods to plugin" do
    assert !TestPlugin.respond_to?(:find_plugin!)
  end

end
