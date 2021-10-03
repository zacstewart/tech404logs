module Tech404logs
  class SearchableMessage
    include DataMapper::Resource
    storage_names[:default] = 'searchable_messages'

    property :id, Serial
    property :channel_id, String
    property :user_id, String
    property :text, Text
    property :timestamp, DateTime

    belongs_to :user
    belongs_to :channel
  end
end
