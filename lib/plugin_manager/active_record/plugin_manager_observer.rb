module PluginManager
  module ActiveRecord

    REGISTERED_CALLBACKS = ::ActiveRecord::Callbacks::CALLBACKS
    #[
    #  :after_initialize, :after_find, :after_touch,
    #  :before_validation, :after_validation,
    #  :before_save, :around_save, :after_save,
    #  :before_create, :around_create, :after_create,
    #  :before_update, :around_update, :after_update,
    #  :before_destroy, :around_destroy, :after_destroy,
    #  :after_commit, :after_rollback
    #]

    class PluginManagerObserver < ::ActiveRecord::Observer

      def self.observed_classes
        p ::ActiveRecord::Base.descendants
        ::ActiveRecord::Base.descendants
      end

      REGISTERED_CALLBACKS.each do |method|
        puts "DEFINING METHOD #{method}"
        define_method method do |record|
          puts "CALLING CB #{method} FOR RECORD #{record}"
          FeatureInterface.run_callback record.model_name.underscore, method, record
        end
      end

      def update(*args, &block)
        p args
      end

      #def method_missing(name, record)
      #  puts "PLUGIN_MANAGER_OBSERVER"+(20*"_")
      #  puts name
      #  p record

      #  super unless respond_to_missing? name
      #  FeatureInterface.run_callback record.class, name, record
      #end

      #def respond_to_missing?(name)
      #  REGISTERED_CALLBACKS.include? name
      #end
    end
  end
end
