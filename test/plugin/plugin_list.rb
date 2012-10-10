class TestPlugin < PluginManager::Plugin
	add_plugin :test_plugin
end

class TestPluginList < Test::Unit::TestCase
	test "added_to_plugin_list" do
		plugin_list = PluginManager::PluginList
		assert_not_same plugin_list[:test_plugin], nil
		assert          plugin_list.plugin? :test_plugin
		assert_same     plugin_list[:test_plugin], plugin_list::PLUGINS[:test_plugin]
		assert_same     plugin_list[:test_plugin], TestPlugin
	end
end
