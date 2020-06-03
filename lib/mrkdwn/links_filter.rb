class LinksFilter
  # handle links, slack mentions (with user lookup), slack channels (with lookup), slack notifications
  LINK = /<([^>|]+)(?:\|([^>]+))?>/.freeze
  class << self
    def convert(text)
      # adapted from slack_markdown
      text = text.gsub(LINK) do |_|
        link_data = Regexp.last_match(1)
        link_text = Regexp.last_match(2)
        create_link(link_data, link_text)
      end
      text
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
        "<a href=\"#{escaped_link}\" class=\"#{EscapeUtils.escape_html(klass)}\">#{EscapeUtils.escape_html(link_text || text)}</a>"
      else
        EscapeUtils.escape_html(link_text || text)
      end
    end
  end
end