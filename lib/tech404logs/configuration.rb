module Tech404logs
  class Configuration
    def self.google_analytics_code
      @google_analytics_code ||= ENV.fetch('GOOGLE_ANALYTICS_CODE') { 'NO CODE' }
    end
  end
end
