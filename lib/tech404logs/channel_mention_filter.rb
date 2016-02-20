module Tech404logs
  class ChannelMentionFilter
    MENTION_PATTERN = /<#(?<id>C[A-Z0-9]+)(?:\|(?<name>[^>]+))?>/

    class UnknownChannel
      def name
        "unknown-channel"
      end
    end

    def self.apply(text)
      new(text).apply
    end

    def initialize(text, channel_repo: Channel)
      @text = text
      @channel_repo = channel_repo
    end

    def apply
      text.gsub(MENTION_PATTERN) do
        name = $~[:name] || find_channel($~[:id]).name
        "##{name}"
      end
    end

    private

    attr_reader :text, :channel_repo

    def find_channel(id)
      channel_repo.get(id) || UnknownChannel.new
    end
  end
end
