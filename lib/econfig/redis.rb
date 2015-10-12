module Econfig
  class Redis
    def initialize(redis)
      @redis = redis
    end

    def keys
      Set.new(@redis.keys)
    end

    def has_key?(key)
      @redis.exists(key)
    end

    def get(key)
      @redis.get(key)
    end

    def set(key, value)
      @redis.set(key, value)
    end
  end
end
