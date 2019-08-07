module Tech404logs
  class Cache
    def initialize
      @memcached = Tech404logs.configuration.memcached
    end

    def fetch(key, ttl = Tech404logs.configuration.cache_ttl, options = {})
      cached = memcached.get(key)
      return cached unless cached.nil?

      fresh = yield
      memcached.set(key, fresh, ttl, options)
      fresh
    end

    private

    attr_reader :memcached
  end
end
