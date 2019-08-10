module Tech404logs
  module Handlers
    class UserHandler

      def initialize
        @table = Sequel::Model.db[:users]
      end

      # Returns the id of the upserted User
      def handle(event_or_id)
        table.insert_conflict(target: :id, update: {
          name: Sequel[:excluded][:name],
          real_name: Sequel[:excluded][:real_name],
          image: Sequel[:excluded][:image],
        }).insert(extract_attributes(event_or_id))
      end

      private

      attr_reader :table

      def extract_attributes(event_or_id)
        case event_or_id
        when Hash
          {
            id: event_or_id.fetch('id'),
            name: event_or_id.fetch('name'),
            real_name: event_or_id.fetch('profile').fetch('real_name'),
            image: event_or_id.fetch('profile').fetch('image_48')
          }
        when String
          {
            id: event_or_id
          }
        end
      end

    end
  end
end
