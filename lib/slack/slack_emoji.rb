require 'slack/slack_client'
require 'open-uri'

class SlackEmoji
  def initialize
    @sc = SlackClient.new
  end

  def update_emoji_aliases
    emoji_aliases.each do |name, alias_for|
      @sc.logger.info "#{name}: #{alias_for}"
      e = EmojiAlias.find_or_initialize_by(name: name)
      e.alias_for = alias_for
      e.save
    end
  end

  def update_custom_emoji
    custom_emoji.each do |name, url|
      @sc.logger.info "#{name}: #{url}"
      e = CustomEmoji.find_or_initialize_by(name: name)
      unless e.emoji.attached?
        extension = File.extname(URI(url).path)
        e.emoji.attach(io: URI.open(url), filename: name + extension)
        e.save
      end
    end
  end

  def custom_emoji
    fetch_slack_emoji.except(*emoji_aliases.keys)
  end

  def emoji_aliases
    fetch_slack_emoji.select { |_, value| value.start_with?('alias:') }
                     .transform_values { |value| /alias:(.*)/.match(value)[1] }
  end

  private

  def fetch_slack_emoji
    @sc.emoji_list&.emoji
  end
end
