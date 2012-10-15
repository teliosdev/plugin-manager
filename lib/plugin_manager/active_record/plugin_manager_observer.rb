module PluginManager
  module ActiveRecord

    REGISTERED_CALLBACKS = []

    class PluginManagerObserver < ::ActiveRecord::Observer
      observe *::ActiveRecord::Base.descendants

      protected

      def method_missing(name, record)
        super unless respond_to_missing? name
        FeatureInterface.run_callback record.class, name, record
      end

      def respond_to_missing?(name)
        REGISTERED_CALLBACKS.include? name
      end
    end
  end
end
