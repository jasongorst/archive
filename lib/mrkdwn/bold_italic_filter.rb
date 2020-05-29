class BoldItalicFilter
  BOLD = /(\*)(?=\S)(.+?[*]*)(?<=\S)\1/
  ITALIC = /(_)(?=\S)(.+?[*]*)(?<=\S)\1/
  STRIKETHROUGH = /(~)(?=\S)(.+?[*]*)(?<=\S)\1/

  BOLD_TAG = 'strong'
  ITALIC_TAG = 'em'
  STRIKETHROUGH_TAG = 'del'

  BOLD_HTML = '<' + BOLD_TAG + '>\2</' + BOLD_TAG + '>'
  ITALIC_HTML = '<' + ITALIC_TAG + '>\2</' + ITALIC_TAG + '>'
  STRIKETHROUGH_HTML = '<' + STRIKETHROUGH_TAG + '>\2</' + STRIKETHROUGH_TAG + '>'

  class << self

    def convert(text)
      text.gsub(BOLD,BOLD_HTML)
          .gsub(ITALIC,ITALIC_HTML)
          .gsub(STRIKETHROUGH,STRIKETHROUGH_HTML)
    end
  end
end
