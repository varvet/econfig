module Econfig
  class ENV
    def get(key)
      ::ENV[key.upcase]
    end
  end
end
