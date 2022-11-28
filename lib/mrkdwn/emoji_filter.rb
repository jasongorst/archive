class EmojiFilter

  class << self

    def convert(text)
      text.gsub(/:([\w+-]+):/) do |match|
        if (emoji = Emoji.find_by_alias(Regexp.last_match(1)))
          emoji.raw || ActionController::Base.helpers.image_tag(emoji.image_filename, alt: match, size: '16')
        else
          match
        end
      end
    end
  end
end
