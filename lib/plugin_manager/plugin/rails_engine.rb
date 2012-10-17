module PluginManager
  module Plugin

    module RailsEngine

      def self.included(base) #:nodoc:
        base.send :extend, ClassMethods
      end

      module ClassMethods

        protected

        def add_plugin(name, *args)
          engine_name name
          super
        end
      end
    end
  end
end
