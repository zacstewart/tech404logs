module Tech404logs
  class Application < Sinatra::Base

    FULLTEXT = "to_tsvector('english', text || ' ' || channels.name || ' ' || users.name) @@ plainto_tsquery(?)".freeze
    HOME_CHANNEL = ENV.fetch('HOME_CHANNEL').freeze

    helpers do
      include Helpers
    end

    before do
      Time.zone = Tech404logs.configuration.time_zone
    end

    get '/' do
      content_type :html

      cache(request.fullpath) do
        @channel = Channel.first(name: HOME_CHANNEL)
        @messages = @channel.messages.on_date(date).ascending
        @canonical_path = channel_path(@channel, date)
        erb :messages
      end
    end

    get %r{/sitemap(.xml)?} do
      content_type :xml

      cache('sitemap', 1.hour) do
        Sitemap.to_xml
      end
    end

    get '/search' do
      content_type :html

      cache(request.fullpath) do
        @messages = Message.all(
          # Trick datamapper into making joins
          Message.channel.id.gt => 0,
          Message.user.id.gt => 0,
          conditions: [FULLTEXT, params[:q]])
        @canonical_path = search_path(params[:q])
        erb :search
      end
    end

    get '/:channel_name/?:date?' do
      content_type :html

      cache(request.fullpath) do
        @channel = Channel.first(name: params[:channel_name])
        not_found unless @channel
        @messages = @channel.messages.on_date(date).ascending
        @canonical_path = channel_path(@channel, date)
        erb :messages
      end
    end

    def not_found
      halt(404, erb(:not_found))
    end

    private

    def cache(key, ttl = 1.minute, options = {})
      cached = memcached.get(key)
      return cached unless cached.nil?

      fresh = yield
      memcached.set(key, fresh, ttl, options)
      fresh
    end

    def memcached
      Tech404logs.configuration.memcached
    end

  end
end
