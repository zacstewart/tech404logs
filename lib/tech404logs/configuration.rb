module Tech404logs
  class Configuration
    def google_analytics_code
      @google_analytics_code ||= ENV.fetch('GOOGLE_ANALYTICS_CODE') { 'NO CODE' }
    end

    def time_zone
      @time_zone ||= ENV.fetch('TIME_ZONE') { 'Eastern Time (US & Canada)' }
    end

    def web_domain
      @web_domain ||= ENV.fetch('WEB_DOMAIN') { "localhost:#{ENV.fetch('PORT')}" }
    end
  end
end
