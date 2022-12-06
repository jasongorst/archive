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
      custom_emoji = CustomEmoji.find_or_initialize_by(name: name) do |e|
        e.url = url
      end

      custom_emoji.with_lock do
        if custom_emoji.url != url
          @sc.logger.info "URL has changed, deleting attachment"
          # delete existing attachment if url has changed
          custom_emoji.emoji.purge
          # then update url
          custom_emoji.url = url
        end

        # if this is a new CustomEmoji (or if we just deleted the attachment), then download the attachment from url
        unless custom_emoji.emoji.attached?
          @sc.logger.info "downloading #{url} and attaching"
          extension = File.extname(URI(url).path)
          custom_emoji.emoji.attach(io: URI.open(url), filename: name + extension)
        end

        custom_emoji.save
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
