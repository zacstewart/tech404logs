migration 4, :add_index_to_messages do
  up do
    execute 'CREATE INDEX messages_channel_id ON messages (channel_id)'
  end

  down do
    execute 'DROP INDEX messages_channel_id'
  end
end
