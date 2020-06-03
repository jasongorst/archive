class EmojiFilter
  class << self
    def convert(text)
      add_slack_aliases
      add_custom_emoji
      add_custom_aliases

      text.gsub(/:([\w+-]+):/) do |match|
        if (emoji = Emoji.find_by_alias(Regexp.last_match(1)))
          # TODO: figure out how to call image_tag and move these into assets
          emoji.raw || "<img src=\"#{emoji.image_filename}\" alt=\"#{match}\" width=\"16\" height=\"16\">"
        else
          match
        end
      end
    end

    def add_slack_aliases
      aliases = {
        'cheese_wedge' => 'cheese',
        'drum_with_drumsticks' => 'drum',
        # 'face_with_raised_eyebrow' => 'raised_eyebrow', # not sure why this one doesn't work
        'face_with_rolling_eyes' => 'roll_eyes',
        'hug' => 'hugs',
        'hugging_face' => 'hugs',
        'sleeping_accommodation' => 'sleeping_bed',
        'thinking_face' => 'thinking',
        'umbrella_with_rain_drops' => 'umbrella',
        'wind_blowing_face' => 'wind_face',
        'woman-lifting-weights' => 'weight_lifting_woman',
        'woman-running' => 'running_woman'
      }
      aliases.each do |new_alias, source|
        emoji = Emoji.find_by_alias(source)
        Emoji.edit_emoji(emoji) do |char|
          char.add_alias new_alias
        end
      end
    end

    def add_custom_emoji
      custom = %w[simple_smile aplus blackcat boggan bowtie cubimal_chick d10 dino
                  dusty_stick eshu glitch_crab jollyroger lioness nab ninja nocker piggy pirate
                  poodle2 pooka possum pride redcap satyr sidhe skunk slack_call slack sluagh
                  soda squirrel teapot thumbsup_all tinfoil troll tumbleweed viking witch]
      custom.each do |emoji|
        Emoji.create(emoji) do |char|
          char.image_filename = "emoji/#{emoji}.png"
        end
      end
    end

    def add_custom_aliases
      aliases = {
        'black_square' => 'black_large_square',
        'lovecraft' => 'blackcat',
        '10' => 'd10',
        'connor' => 'dog',
        'nabuni' => 'nab',
        'emma' => 'possum',
        'shalimar' => 'skunk',
        'shipit' => 'squirrel',
        'white_square' => 'white_large_square'
      }
      aliases.each do |new_alias, source|
        emoji = Emoji.find_by_alias(source)
        Emoji.edit_emoji(emoji) do |char|
          char.add_alias new_alias
        end
      end
    end
  end
end
