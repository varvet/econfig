module Econfig
  class Configuration
    def backends
      @backends ||= []
    end

    def get(key)
      get!(key) or raise Econfig::NotFound, "configuration key '#{key}' is not set"
    end

    def get!(key)
      backend = backends.find { |backend| backend.get(key) }
      backend.get(key) if backend
    end

    def set(key, value)
      backend = backends.find { |backend| backend.respond_to?(:set) }
      backend.set(key, value) if backend
    end

    def method_missing(name, *args)
      name = name.to_s

      if name.end_with?("=")
        set(name.sub(/=$/, ""), args.first)
      elsif args.length > 0
        raise ArgumentError, "too many arguments (#{args.length} for 0)"
      elsif name.end_with?("!")
        get!(name.sub(/!$/, ""))
      else
        get(name)
      end
    end

    def respond_to_missing?(*)
      true
    end
  end
end
