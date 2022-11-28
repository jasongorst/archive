class EmojiFilter

  class << self
    def convert(text)
      add_slack_aliases
      add_custom_emoji
      add_custom_aliases

      text.gsub(/:([\w+-]+):/) do |match|
        if (emoji = Emoji.find_by_alias(Regexp.last_match(1)))
          emoji.raw || ActionController::Base.helpers.image_tag(emoji.image_filename, alt: match, size: '16')
        else
          match
        end
      end
    end

    def add_slack_aliases
      aliases = {
        'cheese_wedge' => 'cheese',
        'drum_with_drumsticks' => 'drum',
        'face_with_raised_eyebrow' => 'raised_eyebrow',
        'face_with_rolling_eyes' => 'roll_eyes',
        'hug' => 'hugs',
        'hugging_face' => 'hugs',
        'sleeping_accommodation' => 'sleeping_bed',
        'thinking_face' => 'thinking',
        'umbrella_with_rain_drops' => 'umbrella',
        'wind_blowing_face' => 'wind_face',
        'woman-lifting-weights' => 'weight_lifting_woman',
        'woman-running' => 'running_woman',
        'waving_white_flag' => 'white_flag'
      }
      aliases.each do |new_alias, source|
        emoji = Emoji.find_by_alias(source)
        Emoji.edit_emoji(emoji) do |char|
          char.add_alias new_alias
        end
      end
    end

    def add_custom_emoji
      CustomEmoji.all.each do |emoji|
        Emoji.create(emoji.name) do |char|
          char.image_filename = Rails.application.routes.url_helpers.rails_blob_path(emoji.emoji, only_path: true)
        end
      end
    end

    def add_custom_aliases
      EmojiAlias.all.each do |emoji_alias|
        emoji = Emoji.find_by_alias(emoji_alias.alias_for)
        Emoji.edit_emoji(emoji) do |char|
          char.add_alias emoji_alias.name
        end
      end
    end
  end
end
