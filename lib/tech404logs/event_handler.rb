module Tech404logs
  class EventHandler
    def self.handle(event)
      new(event).handle
    end

    def initialize(event,
                   channel_joined_handler: ChannelJoinedHandler,
                   message_handler: Handlers::MessageHandler.new,
                   user_handler: Handlers::UserHandler.new)
      @event = MultiJson.load(event)
      @type = @event.fetch('type')
      @channel_joined_handler = channel_joined_handler
      @message_handler = message_handler
      @user_handler = user_handler
    end

    def handle
      case type
      when 'message'
        message_handler.handle(event)
      when 'user_change'
        user_handler.handle(event.fetch('user'))
      when 'channel_joined'
        channel_joined_handler.handle(event)
      end
    end

    private

    attr_reader :channel_joined_handler, :event, :message_handler,
      :type, :user_handler
  end
end
