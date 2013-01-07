module Econfig
  class Configuration
    def backends
      @backends ||= []
    end

    def get(key)
      backend = backends.find { |backend| backend.get(key) }
      backend.get(key) if backend
    end

    def get!(key)
      get(key) or raise Econfig::NotFound, "configuration key '#{key}' is not set"
    end

    def set(key, value)
      backend = backends.find { |backend| backend.respond_to?(:set) }
      backend.set(key, value) if backend
    end

    def method_missing(name, *args)
      if name.to_s.end_with?("=")
        set(name.to_s.sub(/=$/, ""), args.first)
      elsif name.to_s.end_with?("!")
        get!(name.to_s.sub(/!$/, ""))
      else
        get(name.to_s)
      end
    end

    def respond_to?(*)
      true
    end
  end
end
