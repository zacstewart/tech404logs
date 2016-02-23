module Tech404logs
  class Channel
    include DataMapper::Resource
    storage_names[:default] = 'channels'

    property :id, String, key: true
    property :name, String
    property :creator_id, String
    property :member, Boolean

    has n, :messages

    def self.indexing
      all(member: true)
    end

    def self.create_or_update(channel)
      first_or_new(id: channel.fetch('id')).tap do |record|
        record.attributes = {
          name: channel.fetch('name'),
          creator_id: channel.fetch('creator'),
          member: channel.fetch('is_member')
        }
      end.save
    end

    def self.join(channel)
      create_or_update(channel)
    end

    def active_dates
      messages.repository.adapter.select(<<-SQL)
        SELECT
          distinct(date(timestamp)) as date,
          max(timestamp) as last_active_at
        FROM messages
        WHERE channel_id = '#{id}'
        GROUP BY date
        ORDER BY date
      SQL
    end

    def last_active_at
      messages.ascending.last.timestamp
    end

    def last_active_on(date)
      if message = messages.on_date(date).ascending.last
        message.timestamp
      else
        date.to_datetime
      end
    end
  end
end
