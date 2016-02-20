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

    def last_message
      messages.ascending.last
    end
  end
end
