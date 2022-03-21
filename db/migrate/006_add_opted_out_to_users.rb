migration 6, :add_opted_out_to_users do
  up do
    execute 'ALTER TABLE users ADD COLUMN "opted_out" BOOLEAN NOT NULL default false'
  end

  down do
    execute 'ALTER TABLE users DROP COLUMN "opted_out"'
  end
end
