class EmojiFilter < HTML::Pipeline::Filter

  EMOJI_PATTERN = /:([\w+-]+):/

  IGNORE_PARENTS = %w(pre code).to_set

  def call
    doc.search(".//text()").each do |node|
      content = node.text
      next unless content.include?(":")
      next if has_ancestor?(node, IGNORE_PARENTS)
      html = emoji_filter(content)
      next if html == content
      node.replace(html)
    end
    doc
  end

  def emoji_filter(text)
    text.gsub(EMOJI_PATTERN) do |match|
      if (emoji = Emoji.find_by_alias(Regexp.last_match(1)))
        emoji.raw || ActionController::Base.helpers.image_tag(emoji.image_filename, alt: ":#{match}:", size: "16", class: "emoji")
      else
        match
      end
    end
  end
end
