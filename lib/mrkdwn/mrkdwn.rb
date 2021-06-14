require 'mrkdwn/line_break_filter'
require 'mrkdwn/emoji_filter'
require 'mrkdwn/links_filter'
require 'mrkdwn/bold_italic_filter'
require 'mrkdwn/unescape_special'

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
