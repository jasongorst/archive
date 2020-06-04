require_relative 'line_break_filter'
require_relative 'emoji_filter'
require_relative 'links_filter'
require_relative 'bold_italic_filter'
require_relative 'unescape_special'

class Mrkdwn
  class << self
    def convert(text)
      text = LinksFilter.convert(text)
      text = LineBreakFilter.convert(text)
      text = EmojiFilter.convert(text)
      text = BoldItalicFilter.convert(text)
      UnescapeSpecial.convert(text)
    end
  end
end
