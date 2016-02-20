module Tech404logs
  class EventHandler
    def self.handle(event)
      new(event).handle
    end

    def initialize(event,
                   channel_joined_handler: ChannelJoinedHandler)
      @event = MultiJson.load(event)
      @type = @event.fetch('type')
      @channel_joined_handler = channel_joined_handler
    end

    def handle
      case type
      when 'message'
        MessageHandler.handle(event)
      when 'user_change'
        User.store(event.fetch('user'))
      when 'channel_joined'
        channel_joined_handler.handle(event)
      end
    end

    private

    attr_reader :channel_joined_handler, :event, :type
  end
end
