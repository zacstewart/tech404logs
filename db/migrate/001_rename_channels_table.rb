migration 1, :rename_channels_table do
  up do
    execute 'ALTER TABLE tech404_index_channels RENAME TO channels'
  end

  down do
    execute 'ALTER TABLE channels RENAME TO tech404_index_channels'
  end
end
