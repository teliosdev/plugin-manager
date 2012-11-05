# Plugin Manager #
Plugin Manager is a plugin management system for Ruby On Rails.  It allows the Rails Application to internally enable or disable plugins (and their sub, features) without requiring a restart of the whole application.

## Installing ##
You'll have to use cloning from github for now:

	$ git clone git://github.com/redjazz96/plugin-manager

For inclusion in a Gemfile:

	gem 'plugin_manager', :github => "redjazz96/plugin-manager"

## Using ##

### Plugins ###
The Plugin Manager is a tool to help any rails project to keep track of plugins (or gems) that it may be using.  It's just a simple little thing and all it really does is keep track of plugins, features, and enabling/disabling features (and to an extent, plugins).  While creating a plugin, you can use the inheritance method (recommended for non-rails projects), or the `include` method.  The `include` method allows you to make the plugin a `Rails::Engine` or a Railitie:

```Ruby
class Plugin1 < Rails::Engine
  include PluginManager::Plugin
  add_plugin :plugin_1 # this is a required call

  # Sadly, you can't +include+ a Feature.
  class Feature1 < PluginManager::Plugin::Feature
  	add_enable_hook :up
  	def up
  		puts "Hello World!"
  	end
  end

  add_feature :feature_1 # the class name isn't required here, because
  											 # a) it's a child constant of Plugin1 and
  											 # b) the class name can be inferred by the
  											 # feature name.
```

This allows you to add things to the Rails application itself.  If you need to know out there whether or not a certain feature of the plugin is enabled or not, `Plugin1.enabled_feature?(:feature_1)` can help.

### Features ###
Features can be defined anywhere and added to any plugins or even multiple plugins (note that if one plugin disables the feature, it's disabled on all plugins).  Multiple features can be named the same thing on different plugins.  There are three major things about features that are important:

1. `add_enable_hook`.  This allows you to register an _instance method_ (note: not a class method) as a callback for when the feature is enabled.  All hooks are executed in the same instance, so instance variables carry across the hooks; also note that they're executed in the order they're added.
2. `add_disable_hook`.  This allows you to register an _instance method_ as a callback for when the feature is disabled.  See above for instance handling.
3. `init`.  This is always called on enable or disable as an _instance method_ if it's callable.  It's called after both hooks are executed.  `enabled?` will return the value it will return after the feature is done enabling or disabling; that is, it will return true if the feature is enabling, or return false if the feature is disabling.

```Ruby
module MyModule
	class SomeFeature < PluginManager::Plugin::Feature
		add_enable_hook :up

		def up
			# do something...
		end

		def init
			if enabled?
				# same as +add_enable_hook+
			else
				# same as +add_disable_hook+
			end
		end
	end
end

# later...

class MyPlugin < Rails::Engine
	include PluginManager::Plugin
	add_plugin :my_plugin

	add_feature :some_feature, MyModule::SomeFeature
end

```

## License ##
Plugin Manager is licensed under an MIT License (see LICENSE).
