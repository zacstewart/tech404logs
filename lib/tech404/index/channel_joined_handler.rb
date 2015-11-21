module Tech404
  module Index
    class ChannelJoinedHandler
      def self.handle(event)
        new(event).handle
      end

      def initialize(event, channels: Channel)
        @event = event
        @channels = channels
      end

      def handle
        channels.join(event.fetch('channel'))
      end

      private

      attr_reader :event, :channels
    end
  end
end
