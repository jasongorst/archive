require_relative 'line_break_filter'
require_relative 'emoji_filter'
require_relative 'links_filter'
require_relative 'bold_italic_filter'

class Mrkdwn
  class << self
    def convert(text)
      text = LineBreakFilter.convert(text)
      text = EmojiFilter.convert(text)
      text = LinksFilter.convert(text)
      text = BoldItalicFilter.convert(text)
      text
    end
  end
end
