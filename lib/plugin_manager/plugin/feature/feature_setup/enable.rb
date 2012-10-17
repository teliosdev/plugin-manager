module PluginManager
  module Plugin
    class Feature
      module FeatureSetup

        # Provide methods for enabling the feature; this should do
        # things like add methods to the plugin manager observer.
        class Enable
          class << self

            # Add a callback to the observer
            def add_callback sender, name, klass, callback
              #if klass.is_a? Symbol
              #  klass = klass.to_s.camelize.constantize
              #end
              FeatureInterface.add_callback klass, name, callback, sender, &callback
            end
          end
        end
      end
    end
  end
end
