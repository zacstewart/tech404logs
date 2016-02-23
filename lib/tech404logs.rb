require 'active_support/all'
require 'data_mapper'
require 'le'
require 'logger'
require 'sinatra/base'
require 'tech404logs/application'
require 'tech404logs/channel'
require 'tech404logs/channel_mention_filter'
require 'tech404logs/configuration'
require 'tech404logs/link_format_filter'
require 'tech404logs/connection'
require 'tech404logs/channel_joined_handler'
require 'tech404logs/event_handler'
require 'tech404logs/message'
require 'tech404logs/message_format_filter'
require 'tech404logs/message_handler'
require 'tech404logs/user'
require 'tech404logs/user_mention_filter'
require 'tech404logs/version'

module Tech404logs
  def self.configuration
    @configuration ||= Configuration.new
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
  end

  def self.production?
    ENV['RACK_ENV'] == 'production'
  end
end
