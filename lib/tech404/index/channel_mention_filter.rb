module Tech404
  module Index
    class ChannelMentionFilter
      MENTION_PATTERN = /<#(?<id>C[A-Z0-9]+)(?:\|(?<name>[^>]+))?>/

      def self.apply(text)
        new(text).apply
      end

      def initialize(text, channel_repo: Channel)
        @text = text
        @channel_repo = channel_repo
      end

      def apply
        text.gsub(MENTION_PATTERN) do
          name = $~[:name] || channel_repo.get($~[:id]).name
          "##{name}"
        end
      end

      private

      attr_reader :text, :channel_repo
    end
  end
end
