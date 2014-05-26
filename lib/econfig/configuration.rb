module Econfig
  class Configuration
    attr_accessor :default_write_backend

    def backends
      @backends ||= BackendCollection.new
    end

    def fetch(key)
      self[key] or raise Econfig::NotFound, "configuration key '#{key}' is not set"
    end

    def [](key)
      key = key.to_s
      backend = backends.find { |backend| backend.get(key) }
      backend.get(key) if backend
    end

    def []=(backend_name = default_write_backend, key, value)
      raise ArgumentError, "no backend given" unless backend_name
      if backend = backends[backend_name]
        backend.set(key, value)
      else
        raise KeyError, "#{backend_name} is not set"
      end
    end

    def method_missing(name, *args)
      if respond_to?(name)
        raise ArgumentError, "too many arguments (#{args.length} for 0)" if args.length > 0
        fetch(name)
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
