
module Tech404
  module Index
    class Application < Sinatra::Base
      get '/' do
        @channel = Channel.first(name: 'general')
        @messages = @channel.messages(order: [:timestamp.asc])
        content_type :html
        erb :messages
      end

      get '/:channel_name' do
        @channel = Channel.first(name: params[:channel_name])
        @messages = @channel.messages(order: [:timestamp.asc])
        content_type :html
        erb :messages
      end

      helpers do
        def channels
          Channel.all
        end

        def channel_path(channel_or_name)
          name = case channel_or_name
                 when Channel
                   channel_or_name.name
                 when String
                   channel_or_name
                 end
          "/#{name}"
        end
      end
    end
  end
end
