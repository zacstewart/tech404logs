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
      @channel = Channel.first(name: HOME_CHANNEL)
      @messages = @channel.messages.on_date(date).ascending
      @canonical_path = channel_path(@channel, date)
      content_type :html
      erb :messages
    end

    get %r{/sitemap(.xml)?} do
      content_type :xml
      erb :sitemap, layout: false
    end

    get '/search' do
      @messages = Message.all(
        # Trick datamapper into making joins
        Message.channel.id.gt => 0,
        Message.user.id.gt => 0,
        conditions: [FULLTEXT, params[:q]])
      @canonical_path = search_path(params[:q])
      content_type :html
      erb :search
    end

    get '/:channel_name/?:date?' do
      @channel = Channel.first(name: params[:channel_name])
      not_found unless @channel
      @messages = @channel.messages.on_date(date).ascending
      @canonical_path = channel_path(@channel, date)
      content_type :html
      erb :messages
    end

    def not_found
      halt(404, erb(:not_found))
    end

  end
end
