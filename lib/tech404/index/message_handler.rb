module Tech404
  module Index
    class MessageHandler
      def self.handle(message)
        new(message).handle
      end

      def initialize(message)
        @message = MultiJson.load(message.data)
        @type = @message.fetch('type')
      end

      def handle
        case type
        when 'message'
          Message.store(message)
        when 'channel_join', 'channel_leave', 'team_join', 'user_change'
          User.store(message.fetch('user'))
        end
      end

      private

      attr_reader :message, :type
    end
  end
end
