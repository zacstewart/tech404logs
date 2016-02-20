module Tech404logs
  class MessageFormatFilter
    EMPHASIS = /_(.*?)_(\b|$)/
    BOLD = /\*(.*?)\*/
    CODE = /`(..*?)`/
    BLOCKQUOTE = /^>\s*(.*)$/
    PRE = /```(.*?)```/m

    def self.apply(text)
      new(text).apply
    end

    def initialize(text)
      @text = text
    end

    def apply
      text.gsub(EMPHASIS, '<em>\1</em>').
        gsub(BOLD, '<strong>\1</strong>').
        gsub(BLOCKQUOTE, '<blockquote>\1</blockquote>').
        gsub(PRE, '<pre>\1</pre>').
        gsub(CODE, '<code>\1</code>')
    end

    attr_reader :markdown, :text
  end
end
