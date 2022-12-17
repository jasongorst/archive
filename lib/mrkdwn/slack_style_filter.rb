class SlackStyleFilter < HTML::Pipeline::Filter
  # based on HTML::Pipeline::MentionFilter

  STYLE_PATTERN = /([`*_~])(?=\S)(.+?)(?<=\S)\1/

  IGNORE_PARENTS = %w(pre code).to_set

  def call
    doc.search(".//text()").each do |node|
      content = node.to_html
      next unless (
        content.include?("`") or
        content.include?("*") or
        content.include?("_") or
        content.include?("~")
      )
      next if has_ancestor?(node, IGNORE_PARENTS)
      html = style_filter(content)
      next if html == content
      node.replace(html)
    end
    doc
  end

  def style_filter(text)
    text.gsub STYLE_PATTERN do |match|
      style = Regexp.last_match[1]
      text = Regexp.last_match[2]

      # ignore runs of repeated style characters
      if text.match(/\A[#{style}]+\Z/)
        match
      else
        case style
        when "`"
          "<code>#{text}</code>"
        when "*"
          "<strong>#{style_filter(text)}</strong>"
        when "_"
          "<em>#{style_filter(text)}</em>"
        when "~"
          "<del>#{style_filter(text)}</del>"
        else
          match
        end
      end
    end
  end
end
