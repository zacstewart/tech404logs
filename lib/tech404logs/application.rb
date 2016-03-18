module Tech404logs
  class Application < Sinatra::Base
    FULLTEXT = "to_tsvector('english', text || ' ' || channels.name || ' ' || users.name) @@ plainto_tsquery(?)".freeze
    HOME_CHANNEL = ENV.fetch('HOME_CHANNEL').freeze

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

    helpers do
      def date
        if params[:date]
          Time.zone.parse(params[:date][0..10])
        else
          Time.zone.now
        end
      end

      def channels
        Channel.indexing
      end

      def channel_path(channel_or_name, date = nil)
        name = case channel_or_name
               when Channel
                 channel_or_name.name
               when String
                 channel_or_name
               end
        if date
          "/#{name}/#{date.strftime('%Y-%m-%d')}"
        else
          "/#{name}"
        end
      end

      def format_message(text)
        text = UserMentionFilter.apply(text)
        text = ChannelMentionFilter.apply(text)
        text = MessageFormatFilter.apply(text)
        text = LinkFormatFilter.apply(text)
        text
      end

      def format_time(time, format: '%-H:%M')
        time.in_time_zone.strftime(format)
      end

      def message_dom_id(message)
        "message-#{message.id}"
      end

      def message_path(message)
        channel = channel_path(message.channel, message.timestamp)
        "#{channel}##{message_dom_id(message)}"
      end

      def title
        [].tap do |parts|
          parts << @channel.name if @channel
          parts << params[:q] if params[:q]
          parts << 'Tech404logs'
          parts << "Archived transcripts from Atlanta's Tech404 community Slack"
        end.join(' | ')
      end

      def search_path(query)
        "/search?q=#{query}"
      end
    end
  end
end
