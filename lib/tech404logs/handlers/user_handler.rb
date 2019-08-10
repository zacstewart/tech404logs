module Tech404logs
  module Handlers
    class UserHandler

      def initialize
        @table = Sequel::Model.db[:users]
      end

      def handle(event)
        table.insert_conflict(target: :id, update: {
          name: Sequel[:excluded][:name],
          real_name: Sequel[:excluded][:real_name],
          image: Sequel[:excluded][:image],
        }).insert(extract_attributes(event))
      end

      private

      attr_reader :table

      def extract_attributes(event)
        {
          id: event.fetch('id'),
          name: event.fetch('name'),
          real_name: event.fetch('profile').fetch('real_name'),
          image: event.fetch('profile').fetch('image_48')
        }
      end

    end
  end
end
