module Tech404logs
  class Application < Sinatra::Base
    HOME_CHANNEL = ENV.fetch('HOME_CHANNEL').freeze

    before do
      Time.zone = Tech404logs.configuration.time_zone
    end

    get '/' do
      @channel = Channel.first(name: HOME_CHANNEL)
      @messages = @channel.messages.on_date(date).ascending
      content_type :html
      erb :messages
    end

    get %r{/sitemap(.xml)?} do
      content_type :xml
      erb :sitemap, layout: false
    end

    get '/:channel_name/?:date?' do
      @channel = Channel.first(name: params[:channel_name])
      @messages = @channel.messages.on_date(date).ascending
      content_type :html
      erb :messages
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
    end
  end
end
