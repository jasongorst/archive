require 'gemoji'

class EmojiFilter
  class << self
    def convert(text)
      text.gsub(/:([\w+-]+):/) do |match|
        if emoji = Emoji.find_by_alias($1)
          emoji.raw
        else
          match
        end
      end
    end
  end
end