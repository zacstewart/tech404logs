require 'eventmachine'
require 'faye/websocket'
require 'slack/api'
require 'thread'

module Tech404logs
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
      logger.debug 'Connected to RTM socket'
    end

    def on_message(event)
      logger.debug "RTM message received: #{event.data}"
      reactor.defer { EventHandler.handle(event.data) }
    end

    def on_close(close)
      logger.debug "RTM connection closed: #{close.code}, #{close.reason}"
      reactor.stop
      @ws = nil
    end

    private

    attr_reader :reactor, :token, :ws

    def logger
      Tech404logs.logger
    end

    def url
      @url ||= rtm.fetch('url')
    end

    def rtm
      @rtm ||= Slack::Api.new(token).rtm_start
    end

    def sync_channels
      Thread.new do
        rtm.fetch('channels').each do |channel|
          Channel.create_or_update(channel)
        end
      end
    end

    def sync_users
      Thread.new do
        rtm.fetch('users').each do |user|
          User.store(user)
        end
      end
    end
  end
end
