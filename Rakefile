require "bundler/gem_tasks"
require "rake/testtask"
require 'tech404logs'

Rake::TestTask.new(test: ['env:test', 'db:schema:load', :environment]) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

namespace :env do
  task :test do
    ENV['RACK_ENV'] = 'test'
    ENV['DATABASE_URL'] = ENV.fetch('TEST_DATABASE_URL')
  end
end

task :environment do
  Tech404logs.preboot
end

task :reindex => [:environment] do
  Tech404logs.db.execute 'REFRESH MATERIALIZED VIEW searchable_messages'
end

namespace :db do
  task auto: :environment do
    DataMapper.auto_upgrade!
  end

  task :create do
    system("psql #{ENV['DATABASE_URL']} -c '\\q'")
    next if $?.success?

    db_name = ENV['DATABASE_URL'].split('/').last.strip
    sh "createdb #{db_name}"
  end

  task load_migrations: :environment do
    require 'dm-migrations/migration_runner'
    FileList['db/migrate/*.rb'].each do |migration|
      load migration
    end
  end

  task :migrate, [:version] => [:load_migrations] do |t, args|
    if version = args[:version]
      puts "=> Migrating up to version #{version}"
      migrate_up!(version)
    else
      puts '=> Migrating up'
      migrate_up!
    end
  end

  task :rollback, [:verson] => [:load_migrations] do |t, args|
    if version = args[:version]
      puts "=> Rolling back to version #{version}"
      migrate_down!(version)
    else
      puts "=> Rolling back one migration"
      applied = migrations.sort.reverse.drop_while(&:needs_up?).reverse
      current = applied.last
      migrate_down!(current.position - 1)
    end
  end

  namespace :schema do
    task :dump do
      sh "pg_dump -sO #{ENV['DATABASE_URL']} > db/schema.sql"
    end

    task load: 'db:create' do
      sh "psql #{ENV['DATABASE_URL']} < db/schema.sql"
    end
  end
end
