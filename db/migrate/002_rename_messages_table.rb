migration 2, :rename_messages_table do
  up do
    execute 'ALTER TABLE tech404_index_messages RENAME TO messages'
  end

  down do
    execute 'ALTER TABLE messages RENAME TO tech404_index_messages'
  end
end
