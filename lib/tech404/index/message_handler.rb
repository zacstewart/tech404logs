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
        messages.store(message)
      end

      private

      attr_reader :message, :messages, :type
    end
  end
end
