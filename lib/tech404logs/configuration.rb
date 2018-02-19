module Tech404logs
  class Configuration
    def google_analytics_code
      @google_analytics_code ||= ENV.fetch('GOOGLE_ANALYTICS_CODE') { 'NO CODE' }
    end

    def memcached
      return @memcached if defined?(@memcached)

      servers = ENV.fetch('MEMCACHEDCLOUD_SERVERS')
      password = ENV.fetch('MEMCACHEDCLOUD_PASSWORD', nil)
      username = ENV.fetch('MEMCACHEDCLOUD_USERNAME', nil)
      @memcached = Dalli::Client.new(servers,
                                     username: username,
                                     password: password)
    end

    def sitemap_splits
      ENV.fetch('SITEMAP_SPLITS', 3)
    end

    def time_zone
      @time_zone ||= ENV.fetch('TIME_ZONE') { 'Eastern Time (US & Canada)' }
    end

    def use_https?
      @use_https ||= !!ENV.fetch('USE_HTTPS') { false }
    end

    def web_domain
      @web_domain ||= ENV.fetch('WEB_DOMAIN') { "localhost:#{ENV.fetch('PORT')}" }
    end
  end
end
