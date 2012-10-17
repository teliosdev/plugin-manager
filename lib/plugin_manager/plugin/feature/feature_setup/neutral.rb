module PluginManager
  module Plugin
    class Feature
      module FeatureSetup

        # These methods are just basic proxies to Disable or Enable,
        # depending on whether or not the feature is enabled or
        # disabled.  The problem with that is that the class can
        # randomly call a method and it's still recognized by Enable,
        # but it's never Disabled.
        module Neutral

          def self.included(base) #:nodoc:
            base.send :extend, ClassMethods
          end

          module ClassMethods

            def method_missing(name, *args, &block) #:nodoc:
              if enabled?
                if Enable.respond_to? name
                  Enable.send name, *[self, args].flatten, &block
                else
                  super
                end
              else
                if Disable.respond_to? name
                  Disable.send name, *[self, args].flatten, &block
                else
                  super
                end
              end
            end

          end
        end
      end
    end
  end
end
