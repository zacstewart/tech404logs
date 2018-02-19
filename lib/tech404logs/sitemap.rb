require 'erb'

TEMPLATE = ERB.new(File.read('lib/tech404logs/views/sitemap.erb'))

module Tech404logs
  class Sitemap
    include Helpers

    def self.to_xml(channels = Channel.indexing)
      new(channels).to_xml
    end

    def initialize(channels = Channel.indexing)
      @channels = channels
    end

    def to_xml
      TEMPLATE.result(binding)
    end

    private

    attr_reader :channels

    def url(path)
      scheme = if Tech404logs.configuration.use_https?
                 'https'
               else
                 'http'
               end
      domain = Tech404logs.configuration.web_domain
      path.prepend('/') if path[0] != '/'
      "#{scheme}://#{domain}#{path}"
    end
  end
end
