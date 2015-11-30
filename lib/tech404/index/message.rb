module Tech404
  module Index
    class Message
      include DataMapper::Resource

      property :id, Serial
      property :channel_id, String
      property :user_id, String
      property :text, Text
      property :timestamp, DateTime

      belongs_to :user

      def self.store(message)
        transaction do
          create(
            channel_id: message.fetch('channel'),
            user: User.store(message.fetch('user')),
            text: message.fetch('text'),
            timestamp: Time.at(Float(message.fetch('ts')))
          )
        end
      end

      def self.ascending
        all(order: [:timestamp.asc])
      end

      def self.on_date(date)
        all(timestamp: (date...date + 1))
      end
    end
  end
end
