require 'data_mapper'
require 'le'
require 'logger'
require 'sinatra/base'
require 'tech404/index/application'
require 'tech404/index/channel'
require 'tech404/index/channel_mention_filter'
require 'tech404/index/connection'
require 'tech404/index/event_handler'
require 'tech404/index/message'
require 'tech404/index/message_format_filter'
require 'tech404/index/message_handler'
require 'tech404/index/user'
require 'tech404/index/user_mention_filter'
require 'tech404/index/version'

module Tech404
  module Index
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
end
