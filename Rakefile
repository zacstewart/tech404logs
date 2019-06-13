require "bundler/gem_tasks"
require "rake/testtask"
require 'tech404logs'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

task :environment do
  Tech404logs.preboot
end

namespace :db do
  task auto: :environment do
    DataMapper.auto_upgrade!
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
end
