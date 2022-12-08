class LineBreakFilter < HTML::Pipeline::Filter

  IGNORE_PARENTS = %w(pre code).to_set

  def call
    doc.search('.//text()').each do |node|
      content = node.to_html
      next unless content.include?("\n")
      next if has_ancestor?(node, IGNORE_PARENTS)
      html = content.gsub(/\n/,"<br>")
      next if html == content
      node.replace(html)
    end
    doc
  end
end
