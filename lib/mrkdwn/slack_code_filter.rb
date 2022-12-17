class SlackCodeFilter < HTML::Pipeline::Filter

  CODE_PATTERN = /`(?=\S)(.+?)(?<=\S)`/

  IGNORE_PARENTS = %w(pre code).to_set

  def call
    doc.search(".//text()").each do |node|
      content = node.to_html
      next unless content.include?("`")
      next if has_ancestor?(node, IGNORE_PARENTS)
      html = style_filter(content)
      next if html == content
      node.replace(html)
    end
    doc
  end

  def style_filter(text)
    text.gsub CODE_PATTERN do |match|
      text = Regexp.last_match[1]
      "<code>#{text}</code>"
    end
  end
end
