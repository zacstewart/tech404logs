module Tech404logs
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
      when :default, 'channel_join', 'channel_leave', 'channel_topic',
        'channel_purpose', 'channel_name', 'channel_archive',
        'channel_unarchive', 'group_join', 'group_leave', 'group_topic',
        'group_purpose', 'group_name', 'group_archive', 'group_unarchive',
        'file_share', 'file_comment', 'file_mention', 'pinned_item',
        'unpinned_item'
        messages.store(message)
      end
    end

    private

    attr_reader :message, :messages, :type
  end
end
