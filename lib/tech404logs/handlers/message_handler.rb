module Tech404logs
  module Handlers
    class MessageHandler

      REDACTED = '[redacted]'

      def initialize
        @db = Sequel::Model.db
        @table = Sequel::Model.db[:messages]
        @user_handler = UserHandler.new
      end

      # Returns the id of the inerted Message
      def handle(message)
        case message.fetch('subtype') { :default }
        when :default, 'channel_join', 'channel_leave', 'channel_topic',
          'channel_purpose', 'channel_name', 'channel_archive',
          'channel_unarchive', 'group_join', 'group_leave', 'group_topic',
          'group_purpose', 'group_name', 'group_archive', 'group_unarchive',
          'file_share', 'file_comment', 'file_mention', 'pinned_item',
          'unpinned_item'
          store(message)
        end
      end

      private

      attr_reader :db, :table, :user_handler

      def store(message)
        db.transaction do
          user_id = message.fetch('user')
          text = if user_handler.opted_out?(user_id)
            REDACTED
          else
            message.fetch('text')
          end

          table.insert(
            channel_id: message.fetch('channel'),
            user_id: user_handler.handle(user_id),
            text: text,
            timestamp: Time.at(Float(message.fetch('ts')), in: 'utc')
          )
        end
      end

    end
  end
end
