module Tech404logs
  class UserMentionFilter
    MENTION_PATTERN = /<@(?<id>U[A-Z0-9]+)(?:\|(?<name>[^>]+))?>/

    def self.apply(text)
      new(text).apply
    end

    def initialize(text, user_repo: User)
      @text = text
      @user_repo = user_repo
    end

    def apply
      text.gsub(MENTION_PATTERN) do
        name = $~[:name] || user_repo.get($~[:id]).name
        "@#{name}"
      end
    end

    private

    attr_reader :text, :user_repo
  end
end
