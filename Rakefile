require "bundler/gem_tasks"
require "rake/testtask"
require 'tech404logs'

Rake::TestTask.new(test: ['env:test', :environment]) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

namespace :env do
  task :test do
    ENV['RACK_ENV'] = 'test'
  end
end

task :environment do
  case ENV['RACK_ENV']
  when 'development'
  when 'test'
    ENV['DATABASE_URL'] = ENV['TEST_DATABASE_URL']
  when 'production'
  else
    fail 'Unexpected environment'
  end

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
