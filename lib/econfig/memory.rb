module Econfig
  class Memory
    def initialize
      @mutex = Mutex.new
      @options = {}
    end

    def get(key)
      @options[key]
    end

    def set(key, value)
      @mutex.synchronize do
        @options[key] = value
      end
    end
  end
end
