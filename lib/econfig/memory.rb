module Econfig
  class Memory
    def get(key)
      options[key]
    end

    def set(key, value)
      options[key] = value
    end

  private

    def options
      @options ||= {}
    end
  end
end
