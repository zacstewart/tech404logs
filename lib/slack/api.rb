require 'faraday'
require 'multi_json'

module Slack
  class Api
    def initialize(token)
      @token = token
    end

    def rtm_start
      call_api('rtm.start')
    end

    def call_api(method, post_data = {})
      response = connection.post(
        "https://slack.com/api/#{method}",
        {token: token}.merge(post_data)
      )

      unless response.success?
        fail "Slack API call to #{method} failed with status #{response.status}"
      end

      data = MultiJson.load(response.body)

      if data.has_key?('error')
        fail "Slack API call to #{method} failed with error #{data['error']}"
      end

      data
    end

    private

    attr_reader :token

    def connection
      Faraday.new
    end
  end
end
