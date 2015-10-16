module Tech404
  module Index
    class MessageHandler
      def self.handle(message)
        new(message).handle
      end

      def initialize(message)
        @message = message
        @type = @message.fetch('subtype') { :default }
      end

      def handle
        case type
        when :default
          Message.store(message)
        end
      end

      private

      attr_reader :message, :type
    end
  end
end
