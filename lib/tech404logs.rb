require 'active_support/all'
require 'dalli'
require 'data_mapper'
require 'le'
require 'logger'
require 'pg'
require 'sequel'
require 'sinatra/base'

require 'tech404logs/helpers'
require 'tech404logs/application'
require 'tech404logs/cache'
require 'tech404logs/channel'
require 'tech404logs/channel_joined_handler'
require 'tech404logs/channel_mention_filter'
require 'tech404logs/configuration'
require 'tech404logs/connection'
require 'tech404logs/event_handler'
require 'tech404logs/fake_cache'
require 'tech404logs/handlers'
require 'tech404logs/handlers/user_handler'
require 'tech404logs/handlers/message_handler'
require 'tech404logs/link_format_filter'
require 'tech404logs/message'
require 'tech404logs/searchable_message'
require 'tech404logs/message_format_filter'
require 'tech404logs/tasks/task'
require 'tech404logs/tasks/opt_out_user'
require 'tech404logs/tasks/redact_user'
require 'tech404logs/user'
require 'tech404logs/user_mention_filter'
require 'tech404logs/version'
require 'tech404logs/worker_fork'

module Tech404logs
  def self.cache
    @cache ||= if production?
      Cache.new
    else
      FakeCache.new
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.environment
    ENV['RACK_ENV']
  end

  def self.logger
    @logger ||= if production?
      Le.new(ENV['LOGENTRIES_TOKEN'], debug: true, local: true)
    else
      Logger.new(STDOUT)
    end
  end

  def self.preboot
    DataMapper::Logger.new(STDOUT, :debug)
    DataMapper.setup(:default, ENV['DATABASE_URL'])
    DataMapper.finalize

    @db.disconnect if @db
    Sequel::Model.db = @db =
      Sequel.connect(ENV['DATABASE_URL'], logger: logger)

    # Load late so instrumentation gets injected
    if production?
      require 'newrelic_rpm'
    end
  end

  def self.db
    @db
  end


  def self.production?
    environment == 'production'
  end
end
