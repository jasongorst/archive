class SlackMentionFilter < HTML::Pipeline::Filter
  # based on HTML::Pipeline::MentionFilter

  MENTION_PATTERN = /
    &lt;
    ([@#!](?:[a-z0-9][a-z0-9-]*))
    &gt;
  /ix

  IGNORE_PARENTS = %w(pre code a).to_set

  def call
    doc.search(".//text()").each do |node|
      content = node.to_html
      next unless content.include?("@") or content.include?("#") or content.include?("!")
      next if has_ancestor?(node, IGNORE_PARENTS)
      html = mention_filter(content)
      next if html == content
      node.replace(html)
    end
    doc
  end

  def mention_filter(text)
    text.gsub MENTION_PATTERN do |match|
      mention = Regexp.last_match[1]

      case mention
      when /\A#(C.+)\Z/ # slack channel
        if context.dig(:slack_channels, Regexp.last_match[1])
          "<span class=\"channel\">\##{context[:slack_channels][Regexp.last_match[1]]}</span>"
        else
          "<span class=\"channel\">#{mention}</span>"
        end

      when /\A@([UB].+)\Z/ # slack user or bot
        if context.dig(:slack_users, Regexp.last_match[1])
          "<span class=\"user\">@#{context[:slack_users][Regexp.last_match[1]]}</span>"
        else
          "<span class=\"user\">#{mention}</span>"
        end

      when /\A!(here|channel|everyone)\Z/ # special mention
        "<span class=\"mention\">@#{Regexp.last_match[1]}</span>"

      else
        match
      end
    end
  end
end
