module Econfig
  class Redis
    def initialize(redis)
      @redis = redis
    end

    def get(key)
      @redis.get("econfig_#{key}")
    end

    def set(key, value)
      @redis.set("econfig_#{key}", value)
    end
  end
end
