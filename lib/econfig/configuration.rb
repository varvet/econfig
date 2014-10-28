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
      backends.each do |backend|
        value = backend.get(key.to_s)
        return value if value
      end
      nil
    end

    def []=(backend_name = default_write_backend, key, value)
      raise ArgumentError, "no backend given" unless backend_name
      if backend = backends[backend_name]
        backend.set(key.to_s, value)
      else
        raise KeyError, "#{backend_name} is not set"
      end
    end

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
