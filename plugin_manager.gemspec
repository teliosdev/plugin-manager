lib_folder = File.absolute_path('../lib', __FILE__)
require "#{lib_folder}/plugin_manager/version"

Gem::Specification.new do |spec|
	spec.name    = "plugin_manager"
	spec.version = PluginManager::VERSION
	spec.summary = "A Rails Plugin Management System"
	spec.authors = "Jeremy Rodi"
	spec.email   = "redjazz96@gmail.com"
	spec.files   = Dir["lib/**/*.rb"] + %w(README.md LICENSE)
	spec.has_rdoc= true

	spec.required_ruby_version = '>= 1.8.1'
	spec.description = <<-DOC
	A Rails Plugin management system, that keeps track of your plugins and allows for diabling or enabling of the plugins.
DOC
	spec.add_dependency 'active_support', ">= 3.2"
end
