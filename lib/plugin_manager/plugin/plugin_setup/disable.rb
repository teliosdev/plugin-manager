module PluginManager
  class PluginSetup

    # Methods available to the +init+/+down+ methods for disabling
    # the plugin, such as +add_class_methods+ or other methods.
    module Disable
      class << self
        # Add the instance methods from the class/module +from+ to the
        # class/module +klass+ via +include+.
        def add_instance_methods(klass, from)
          from.instance_methods.each do |m|
            #p klass.new.test_2
            klass.instance_exec do
              undef_method m
            end

            #klass.send :remove_method, method
          end
        end

        # Add the class methods from the class/module +from+ to the
        # class/module +klass+ via +extend+.
        def add_class_method(klass, from)
          from.methods.each do |method|
            klass.send :remove_method, method
          end
        end
      end

    end
  end
end
