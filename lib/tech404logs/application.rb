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

    get '/sitemap' do
      redirect to('/sitemap.xml')
    end

    get '/sitemap.xml' do
      content_type :xml
      erb :sitemap, layout: nil
    end

    get '/root_sitemap.xml' do
      content_type :xml
      erb :root_sitemap, layout: nil
    end

    get '/:channel_name/sitemap' do
      channel = Channel.first(name: params[:channel_name])
      not_found unless channel
      redirect to(channel_sitemap_path(channel.name)), 302
    end

    get '/:channel_name/sitemap.xml' do
      @channel = Channel.first(name: params[:channel_name])
      not_found unless @channel
      content_type :xml
      erb :channel_sitemap, layout: nil
    end

    get '/search' do
      content_type :html

      cache(request.fullpath) do
        @messages = Message.all(
          # Trick datamapper into making joins
          Message.channel.id.gt => 0,
          Message.user.id.gt => 0,
          conditions: [FULLTEXT, params[:q]],
          limit: 100
        )
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

    def cache(key, ttl = Tech404logs.configuration.cache_ttl, options = {}, &block)
      Tech404logs.cache.fetch(key, ttl, options, &block)
    end

  end
end
