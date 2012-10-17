module PluginManager
  module Plugin
    class Feature
      module FeatureSetup

        # Takes down what enable did; if it added callbacks, this
        # removes callbacks.  Every Enable method should have a
        # Disable method.
        class Disable

          # Remove the callback from the FeatureInterface.
          def add_callback sender, name, klass, callback
            if klass.is_a? Symbol
              klass = klass.to_s.camelize.constantize
            end
            FeatureInterface.remove_callback klass, name, callback
          end

        end
      end
    end
  end
end
