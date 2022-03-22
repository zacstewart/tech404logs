module Tech404logs
  class FakeCache
    def initialize
    end

    def fetch(key, ttl = Tech404logs.configuration.cache_ttl, options = {})
      yield
    end
  end
end

