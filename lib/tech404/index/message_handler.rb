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
        end
      end

      private

      attr_reader :message, :type
    end
  end
end
