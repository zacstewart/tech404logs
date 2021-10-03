module Tech404logs
  class Application < Sinatra::Base

    FULLTEXT = "tsv @@ plainto_tsquery(?)".freeze
    HOME_CHANNEL = ENV.fetch('HOME_CHANNEL').freeze
    SEARCH_RESULTS_PER_PAGE = 100

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
        @results_count = SearchableMessage.count(
          conditions: [FULLTEXT, params[:q]]
        )
        @messages = SearchableMessage.all(
          conditions: [FULLTEXT, params[:q]],
          order: :timestamp.desc,
          limit: SEARCH_RESULTS_PER_PAGE,
          offset: (page - 1) * SEARCH_RESULTS_PER_PAGE
        )

        @pages = (@results_count.to_f / SEARCH_RESULTS_PER_PAGE).ceil

        @canonical_path = search_path(params[:q], page: page)
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

    def page
      [params.fetch(:page, 1).to_i, 1].max
    end

  end
end
