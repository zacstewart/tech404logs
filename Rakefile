require "bundler/gem_tasks"
require "rake/testtask"
require 'tech404/index'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

namespace :db do
  task :migrate do
    Tech404::Index.preboot
    DataMapper.auto_upgrade!
  end
end
