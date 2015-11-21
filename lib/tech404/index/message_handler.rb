module Tech404
  module Index
    class MessageHandler
      def self.handle(message)
        new(message).handle
      end

      def initialize(message, messages: Message)
        @message = message
        @type = @message.fetch('subtype') { :default }
        @messages = messages
      end

      def handle
        case type
        when :default
          messages.store(message)
        end
      end

      private

      attr_reader :message, :messages, :type
    end
  end
end
