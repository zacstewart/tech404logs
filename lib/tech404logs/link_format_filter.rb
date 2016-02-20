module Tech404logs
  class LinkFormatFilter
    LINK_PATTERN = /\<(?<url>http[^\|>]+)(\|(?<label>[^\>]*))?\>/

    def self.apply(text)
      new(text).apply
    end

    def initialize(text)
      @text = text
    end

    def apply
      text.gsub(LINK_PATTERN) do
        url = $~[:url]
        label = $~[:label] || url
        %{<a href="#{url}">#{label}</a>}
      end
    end

    private

    attr_reader :text
  end
end
