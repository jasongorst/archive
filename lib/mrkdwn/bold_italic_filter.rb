class BoldItalicFilter
  ESCAPE_RUN = /\*{2,}|_{2,}|~{2,}/
  UNESCAPE_RUN = /{([+-=]),(\d+)}/
  ESCAPE_CHARS = {
    '*' => "\801",
    '_' => "\802",
    '~' => "\803"
  }
  UNESCAPE_CHARS = ESCAPE_CHARS.invert
  EMOJI = /:(?=\S).+?(?<=\S):/
  ESCAPED_EMOJI = /!(?=\S).+?(?<=\S)!/
  BOLD = /(\*)(?=\S)(.+?)(?<=\S)\1/
  ITALIC = /(_)(?=\S)(.+?)(?<=\S)\1/
  STRIKE = /(~)(?=\S)(.+?)(?<=\S)\1/
  BOLD_TAG = 'strong'
  ITALIC_TAG = 'em'
  STRIKE_TAG = 'del'
  BOLD_HTML = '<' + BOLD_TAG + '>\2</' + BOLD_TAG + '>'
  ITALIC_HTML = '<' + ITALIC_TAG + '>\2</' + ITALIC_TAG + '>'
  STRIKE_HTML = '<' + STRIKE_TAG + '>\2</' + STRIKE_TAG + '>'

  class << self
    def convert(text)
      text = escape_runs(text)
      text = escape_emoji(text)
      text = text.gsub(BOLD, BOLD_HTML)
                 .gsub(ITALIC, ITALIC_HTML)
                 .gsub(STRIKE, STRIKE_HTML)
      text = unescape_emoji(text)
      unescape_runs(text)
    end

    def escape_runs(text)
      # escape runs of special chars
      # format '{char,length}'
      # where char is replaced by:
      #   * => +
      #   => -
      #   ~ => =
      while text =~ ESCAPE_RUN
        position = (text =~ ESCAPE_RUN)
        match = text.match ESCAPE_RUN
        length = match.to_s.length
        char = ESCAPE_CHARS[match.to_s[0]]
        text[position...(position + length)] = '{' + char + ',' + length.to_s + '}'
      end
      text
    end

    def unescape_runs(text)
      while text =~ UNESCAPE_RUN
        position = (text =~ UNESCAPE_RUN)
        match = text.match UNESCAPE_RUN
        length = match.to_s.length
        char = UNESCAPE_CHARS[match[1]]
        run = match[2].to_i
        text[position...(position + length)] = char * run
      end
      text
    end

    def escape_emoji(text)
      while text =~ EMOJI
        match = text.match EMOJI
        replace = match.to_s.tr(':_', '!-')
        text = text.gsub(match.to_s, replace)
      end
      text
    end

    def unescape_emoji(text)
      while text =~ ESCAPED_EMOJI
        match = text.match ESCAPED_EMOJI
        replace = match.to_s.tr('!-', ':_')
        text = text.gsub(match.to_s, replace)
      end
      text
    end
  end
end
