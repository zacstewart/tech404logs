$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start { add_filter '/test/' }

require 'tech404logs'

require 'byebug'
require 'minitest/spec'
require 'mocha/mini_test'
require 'minitest/autorun'
require 'database_cleaner'

class FunctionalSpec < MiniTest::Spec
  before do
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end
end

MiniTest::Spec.register_spec_type(/^Tech404logs::Handlers::/, FunctionalSpec)

include Tech404logs
Tech404logs.preboot
