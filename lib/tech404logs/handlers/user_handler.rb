module Tech404logs
  module Handlers
    class UserHandler

      def initialize
        @db = Sequel::Model.db
        @table = Sequel::Model.db[:users]
      end

      # Returns the id of the upserted User
      def handle(event_or_id)
        case event_or_id
        when Hash
          upsert_user(event_or_id)
        when String
          table.insert_ignore.insert(id: event_or_id)
          event_or_id
        end
      end

      def opted_out?(user_id)
        table.where(id: user_id, opted_out: true).count > 0
      end

      private

      attr_reader :db, :table

      def upsert_user(event)
        db.transaction do
          user_id = event.fetch('id')
          return user_id if opted_out?(user_id)

          table.insert_conflict(target: :id, update: {
            name: Sequel[:excluded][:name],
            real_name: Sequel[:excluded][:real_name],
            image: Sequel[:excluded][:image],
          }).insert(
            id: user_id,
            name: event.fetch('name'),
            real_name: event.fetch('profile').fetch('real_name'),
            image: event.fetch('profile').fetch('image_48')
          )
        end
      end

    end
  end
end
