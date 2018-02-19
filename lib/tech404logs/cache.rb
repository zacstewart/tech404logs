module Tech404logs
  class Cache
    def initialize
      @memcached = Tech404logs.configuration.memcached
    end

    def fetch(key, ttl = 1.minute, options = {})
      cached = memcached.get(key)
      return cached unless cached.nil?

      fresh = yield
      memcached.set(key, fresh, ttl, options)
      fresh
    end

    def set_splits(key_prefix, splits, value)
      size = (value.length.to_f / splits).floor
      value.chars.each_slice(size).each_with_index do |chunk, index|
        memcached.set("#{key_prefix}_#{index}", chunk)
      end
    end

    def get_splits(key_prefix, splits)
      keys = splits.times.map { |i| "#{key_prefix}_#{i}" }
      values = []
      memcached.get_multi(keys) do |key, value|
        values << value
      end
      values.join('')
    end

    private

    attr_reader :memcached
  end
end
