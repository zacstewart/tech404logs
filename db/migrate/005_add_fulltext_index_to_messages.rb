migration 5, :add_fulltext_index_to_messages do
  up do
    execute <<~SQL
      CREATE MATERIALIZED VIEW searchable_messages AS
        SELECT
          messages.*,
          channels.name AS channel_name,
          users.image AS user_image,
          users.real_name AS user_real_name,
          users.name AS user_name,
          to_tsvector(messages.text || ' ' || channels.name || ' ' || users.real_name || ' ' || users.name) AS tsv
        FROM messages
        INNER JOIN users ON messages.user_id = users.id
        INNER JOIN channels ON messages.channel_id = channels.id
      WITH NO DATA;
    SQL

    execute 'CREATE INDEX searchable_messages_tsv ON searchable_messages USING gin(tsv)'
  end

  down do
    execute 'DROP INDEX searchable_messages_tsv'
    execute 'DROP MATERIALIZED VIEW searchable_messages;'
  end
end
