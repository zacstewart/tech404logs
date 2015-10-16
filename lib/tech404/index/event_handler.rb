module Tech404
  module Index
    class EventHandler
      def self.handle(event)
        new(event).handle
      end

      def initialize(event)
        @event = MultiJson.load(event.data)
        @type = @event.fetch('type')
      end

      def handle
        case type
        when 'message'
          MessageHandler.handle(event)
        when 'channel_join', 'channel_leave', 'team_join', 'user_change'
          User.store(event.fetch('user'))
        end
      end

      private

      attr_reader :event, :type
    end
  end
end
