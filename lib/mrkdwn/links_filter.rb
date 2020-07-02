class LinksFilter
  # handle url links, slack mentions, slack channels, slack notifications
  LINK = /<([^>|]+)(?:\|([^>]+))?>/.freeze
  class << self
    def convert(text)
      # adapted from slack_markdown
      text.gsub(LINK) do |_|
        link_data = Regexp.last_match(1)
        link_text = Regexp.last_match(2)
        create_link(link_data, link_text)
      end
    end

    private

    def create_link(data, link_text = nil)
      klass, link, text =
        case data
        when /\A#(C.+)\z/ # slack channel
          # look up channel by slack_channel
          channel = Channel.find_by(slack_channel: Regexp.last_match(1))
          channel_name = if channel
                           # TODO: figure out where the "#" goes
                           "\##{channel.name}"
                         else
                           data
                         end
          ['channel', nil, channel_name]
        when /\A@([UB].+)/ # slack user or bot
          # look up user by slack_user
          user = User.find_by(slack_user: Regexp.last_match(1))
          user_display_name = if user
                                "@#{user.display_name}"
                              else
                                data
                              end
          ['mention', nil, user_display_name]
        when /\A@(.+)/ # slack user name
          ['mention', nil, data]
        when /\A!/ # special slack command
          ['link', nil, data]
        else # normal link
          ['link', data, data]
        end

      if link
        escaped_link = EscapeUtils.escape_html(link).to_s
        escaped_link = escape_special(escaped_link)
        if link_text.nil?
          text = EscapeUtils.escape_html(text)
          text = escape_special(text)
        else
          link_text = EscapeUtils.escape_html(link_text)
          link_text = escape_special(link_text)
        end
        "<a href=\"#{escaped_link}\" class=\"#{EscapeUtils.escape_html(klass)}\">#{link_text || text}</a>"
      else
        link_text || text
      end
    end

    def escape_special(text)
      # escape _/*/~ so they don't get munged by BoldItalicFilter
      text.gsub(/\*/, '&#42;')
          .gsub(/_/, '&#95;')
          .gsub(/~/, '&#126;')
    end
  end
end
