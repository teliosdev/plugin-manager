require 'test_plugin'

class TestPluginFeatures < Test::Unit::TestCase

  class TestFeature; end

  test "throws errors for bad calls" do
    # I didn't call +add_plugin+ before I called +add_feature+.
    assert_raise PluginManager::PluginListError do
      Class.new(PluginManager::Plugin) do
        add_feature :hello, TestFeature
      end
    end

    # TestFeature isn't a decendent of +PluginManager::Plugin::Feature+.
    assert_raise PluginManager::PluginListError do
      Class.new(PluginManager::Plugin) do
        add_plugin :fake_plugin

        add_feature :hello, TestFeature
      end
    end
  end

  test "adds features to list" do
    pl = PluginManager::Plugin::PluginList
    assert_not_nil pl.features[:test_plugin][:test_1]
    assert_same pl.features[:test_plugin][:test_1], TestPlugin::Test1
  end

end
