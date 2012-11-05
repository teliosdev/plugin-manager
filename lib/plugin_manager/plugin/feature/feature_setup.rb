module PluginManager
  module Plugin
    class Feature

      # This enables/disables the feature.  It uses a method called
      # +init+ to keep track of what things need to be done to enable or
      # disable the feature, such as activerecord hooks.  It also keeps
      # a list of +enable+ or +disable+ methods that are called on
      # either trigger.
      module FeatureSetup

        def self.included(base) #:nodoc:
          base.send :extend, ClassMethods
        end

        module ClassMethods

          # Add +enable+ hooks to the feature.  The arguments can be
          # taken as an array, multiple arguments, or just a single
          # argument.
          def add_enable_hook(*methods)
            methods.flatten!
            @_enable_hooks ||= []
            @_enable_hooks.push *methods
          end

          # Add +disable+ hooks to the feature.  See #add_enable_hook.
          def add_disable_hook(*methods)
            methods.flatten!
            @_disable_hooks ||= []
            @_disable_hooks.push *methods
          end

          # Enable the feature.  It uses +init+ to run the initial setup
          # things, like add active record callbacks.  It runs +init+
          # before triggering the enable hooks.
          def enable
            return if enabled?
            @_enabled = true
            i = _trigger_enable_hooks
            i.send :init if i.respond_to? :init
          end

          # Disable the feature.  It uses +init+ to run the final
          # shutdown of things, after triggering the disable hooks.
          def disable
            return unless enabled?
            @_enabled = false
            i = _trigger_disable_hooks
            i.send :init if i.respond_to? :init
          end

          # Determines whether or not the plugin is enabled.  If it
          # can't be determined, then it's false.
          def enabled?
            !!@_enabled # turn it into a guarenteed bool
          end

          private

          def _trigger_enable_hooks #:nodoc:
            instance = self.new
            return instance unless @_enable_hooks and @_enable_hooks.length > 0
            @_enable_hooks.each do |m|
              instance.send m
            end
            instance
          end

          def _trigger_disable_hooks #:nodoc:
            return instance unless @_disable_hooks and @_disable_hooks.length > 0
            instance = self.new
            @_disable_hooks.each do |m|
              instance.send m
            end
            instance
          end

        end
      end
    end
  end
end
