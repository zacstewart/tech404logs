require 'readline'
require 'pp'

module Tech404logs
  module Tasks
    class RedactUser < Task

      DELETED = '[deleted]'
      DELETED_IMAGE = '/deleted-user.png'
      REDACTED = '[redacted]'

      def self.run
        new.run
      end

      def initialize
        super
        @users = Sequel::Model.db[:users]
        @messages = Sequel::Model.db[:messages]
      end

      def run
        puts "Please enter the user's ID (It looks like U03H0B61B)"
        user_id = Readline.readline("> ").strip
        db.transaction do
          if user = find_user(user_id)
            pp user
            message_count = messages.where(user_id: user_id).count
            puts "#{message_count} messages"

            confirm('Are you sure you want to redact this user?') do
              blank_out_user_profile(user_id)
              redact_users_messages(user_id)
            end
          else
            puts "That user doesn't exist."
          end
        end
      end

      private

      attr_reader :db, :messages, :users

      def blank_out_user_profile(user_id)
        users.where(id: user_id).update(
          name: DELETED,
          real_name: DELETED,
          image: DELETED_IMAGE
        )
      end

      def redact_users_messages(user_id)
        messages.where(user_id: user_id).update(
          text: REDACTED
        )
      end

    end
  end
end
