module Econfig
  class Configuration
    def backends
      @backends ||= BackendCollection.new
    end

    def set(key, value)
      backend = backends.find { |backend| backend.respond_to?(:set) }
      backend.set(key, value) if backend
    end

    def fetch(key)
      self[key] or raise Econfig::NotFound, "configuration key '#{key}' is not set"
    end

    def [](key)
      key = key.to_s
      backend = backends.find { |backend| backend.get(key) }
      backend.get(key) if backend
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
