module Econfig
  class ENV
    def has_key?(key)
      ::ENV.has_key?(key.upcase)
    end

    def get(key)
      ::ENV[key.upcase]
    end
  end
end
