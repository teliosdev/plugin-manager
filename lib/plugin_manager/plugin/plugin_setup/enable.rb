module PluginManager
	class PluginSetup

		# Methods available to the +init+/+up+ methods for enabling
		# the plugin, such as +add_class_methods+ or other methods.
		module Enable
			class << self
				# Add the instance methods from the class/module +from+ to the
				# class/module +klass+ via +include+.
				def add_instance_methods(klass, from)
					klass.send :include, from
				end

				# Add the class methods from the class/module +from+ to the
				# class/module +klass+ via +extend+.
				def add_class_method(klass, from)
					klass.send :extend, from
				end
			end

		end
	end
end
