migration 3, :rename_users_table do
  up do
    execute 'ALTER TABLE tech404_index_users RENAME TO users'
  end

  down do
    execute 'ALTER TABLE users RENAME TO tech404_index_users'
  end
end
