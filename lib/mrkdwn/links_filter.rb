class LinksFilter
  # handle links, slack mentions (with user lookup), slack channels (with lookup), slack notifications
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
          # TODO: look up channel via slack api
          ['channel', nil, data]
        when /\A@((?:U|B).+)/ # slack user or bot
          # TODO: look up user via slack api
          ['mention', nil, data]
        when /\A@(.+)/ # slack user name
          # TODO: look up user by name via slack api
          ['mention', nil, data]
        when /\A!/ # special slack command
          ['link', nil, data]
        else # normal link
          ['link', data, data]
        end

      if link
        escaped_link = EscapeUtils.escape_html(link).to_s
        # escape _/*/~ in link and link_text || text so they don't get munged by BoldItalicFilter
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
      text.gsub(/\*/, '&#42;')
          .gsub(/_/, '&#95;')
          .gsub(/~/, '&#126;')
    end
  end
end