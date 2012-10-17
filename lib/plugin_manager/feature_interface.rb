module PluginManager

  # Keeps track of all the callbacks for the features.  Allows for
  # addition of callbacks, and removal.
  module FeatureInterface

    CALLBACKS = Hash.new do |h, k|
      h[k] = Hash.new { |hsh, key| hsh[key] = {} }
    end

    class << self
      # Add a callback.
      def add_callback(klass, event, cb_name, owner, &block)
        CALLBACKS[klass][event][cb_name] = [owner, block]
      end

      # Remove a callback.
      def remove_callback(klass, event, cb_name)
        CALLBACKS[klass][event].delete cb_name
      end

      # Run a callback of the specified class and event.
      def run_callback(klass, event, *arguments)
        arguments.flatten!
        CALLBACKS[klass][event].each do |k, v|
          v[1].call v[0], *arguments if v
        end
      end

    end
  end
end
