module Econfig
  class Configuration
    attr_accessor :default_write_backend

    attr_reader :backends, :casts

    def initialize
      @backends ||= BackendCollection.new
      @casts ||= {}
    end

    def cast(key, &block)
      casts[key.to_s] = block
    end

    def keys
      backends.keys
    end

    def fetch(key)
      get(key) do
        raise Econfig::NotFound, "configuration key '#{key}' is not set"
      end
    end

    def get(key)
      key = key.to_s
      value = backends.get(key) do
        yield if block_given?
        return nil
      end
      value = casts[key].call(value) if casts[key]
      value
    end
    alias_method :[], :get

    def set(backend_name = default_write_backend, key, value)
      raise ArgumentError, "no backend given" unless backend_name
      if backend = backends[backend_name]
        backend.set(key.to_s, value)
      else
        raise KeyError, "#{backend_name} is not set"
      end
    end
    alias_method :[]=, :set

    def method_missing(name, *args)
      if respond_to?(name)
        raise ArgumentError, "too many arguments (#{args.length} for 0)" if args.length > 0
        if ::ENV["ECONFIG_PERMISSIVE"].to_s.empty?
          fetch(name)
        else
          self[name]
        end
      else
        super
      end
    end

    def respond_to_missing?(name, *)
      name = name.to_s
      not(name.end_with?("=") or name.end_with?("!") or name.end_with?("?"))
    end
  end
end
