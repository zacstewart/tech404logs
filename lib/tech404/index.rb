require 'data_mapper'
require 'logger'
require 'sinatra/base'
require 'tech404/index/application'
require 'tech404/index/channel'
require 'tech404/index/channel_mention_filter'
require 'tech404/index/connection'
require 'tech404/index/message'
require 'tech404/index/message_handler'
require 'tech404/index/user'
require 'tech404/index/user_mention_filter'
require 'tech404/index/version'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.finalize
DataMapper.auto_upgrade!

module Tech404
  module Index
    def self.logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
