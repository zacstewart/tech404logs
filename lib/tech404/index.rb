require 'pp'
require 'data_mapper'
require 'eventmachine'
require 'faye/websocket'
require 'sinatra/base'
require 'slack/api'
require 'tech404/index/application'
require 'tech404/index/channel'
require 'tech404/index/message'
require 'tech404/index/message_handler'
require 'tech404/index/user'
require 'tech404/index/version'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.finalize
DataMapper.auto_upgrade!

module Tech404
  module Index
    class Connection
      def initialize(token = ENV['SLACK_TOKEN'])
        @token = token
        @reactor = EM
        @ws = nil
      end

      def run
        sync_channels
        sync_users

        reactor.run do
          @ws = Faye::WebSocket::Client.new(url, [])
          ws.onopen = method(:on_open)
          ws.onclose = method(:on_close)
          ws.onmessage = method(:on_message)
        end
      end

      def on_open(event)
        pp "ohai"
      end

      def on_message(message)
        reactor.defer { MessageHandler.handle(message) }
      end

      def on_close(close)
        pp("connection closed: #{close.code}, #{close.reason}")
        reactor.stop
        @ws = nil
      end

      private

      attr_reader :reactor, :token, :ws

      def url
        rtm.fetch('url')
      end

      def rtm
        @rtm ||= Slack::Api.new(token).rtm_start
      end

      def sync_channels
        rtm.fetch('channels').each do |channel|
          Channel.create_or_update(channel)
        end
      end

      def sync_users
        rtm.fetch('users').each do |user|
          User.create_or_update(user)
        end
      end
    end
  end
end
