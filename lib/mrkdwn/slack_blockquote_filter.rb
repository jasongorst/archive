class SlackBlockquoteFilter < HTML::Pipeline::Filter

  BLOCKQUOTE_PATTERN = /
    (
      (?:^>.*$\R?)+
    )
  /x

  IGNORE_PARENTS = %w(pre code).to_set

  def call
    doc.search(".//text()").each do |node|
      content = node.to_html
      next unless content.include?(">")
      next if has_ancestor?(node, IGNORE_PARENTS)
      html = link_filter(content)
      next if html == content
      node.replace(html)
    end
    doc
  end

  def link_filter(text)
    text.gsub BLOCKQUOTE_PATTERN do |match|
      text = Regexp.last_match[1].chomp

      "<blockquote>#{text}</blockquote>"
    end
  end
end
