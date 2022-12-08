class SlackLinkFilter < HTML::Pipeline::Filter

  LINK_PATTERN = /
    &lt;
    (
      (?:http|mailto)
      [^&|]+
    )
    (?:\|([^&]+))?
    &gt;
  /x

  IGNORE_PARENTS = %w(pre code a).to_set

  def call
    doc.search('.//text()').each do |node|
      content = node.to_html
      next if has_ancestor?(node, IGNORE_PARENTS)
      html = link_filter(content)
      next if html == content
      node.replace(html)
    end
    doc
  end

  def link_filter(text)
    text.gsub LINK_PATTERN do |match|
      link = Regexp.last_match[1]
      text = Regexp.last_match[2] || link

      "<a href=\"#{link}\">#{text}</a>"
    end
  end
end
