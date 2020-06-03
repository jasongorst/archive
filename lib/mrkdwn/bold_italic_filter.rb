class BoldItalicFilter
  ESCAPE_RUN = /\*{2,}|_{2,}|~{2,}/.freeze
  ESCAPE_ENTITIES = {
    '*' => '&#42;',
    '_' => '&#95;',
    '~' => '&#126;'
  }.freeze
  EMOJI = /:(?=\S).+?(?<=\S):/.freeze
  ESCAPED_EMOJI = /!(?=\S).+?(?<=\S)!/.freeze
  BOLD = /(\*)(?=\S)(.+?)(?<=\S)\1/.freeze
  ITALIC = /(_)(?=\S)(.+?)(?<=\S)\1/.freeze
  STRIKE = /(~)(?=\S)(.+?)(?<=\S)\1/.freeze
  BOLD_TAG = 'strong'.freeze
  ITALIC_TAG = 'em'.freeze
  STRIKE_TAG = 'del'.freeze
  BOLD_HTML = '<' + BOLD_TAG + '>\2</' + BOLD_TAG + '>'
  ITALIC_HTML = '<' + ITALIC_TAG + '>\2</' + ITALIC_TAG + '>'
  STRIKE_HTML = '<' + STRIKE_TAG + '>\2</' + STRIKE_TAG + '>'

  class << self
    def convert(text)
      text = escape_runs(text)
      # text = escape_emoji(text)
      text = text.gsub(BOLD, BOLD_HTML)
                 .gsub(ITALIC, ITALIC_HTML)
                 .gsub(STRIKE, STRIKE_HTML)
      # text = unescape_emoji(text)
      text
    end

    def escape_runs(text)
      # escape runs of special chars with their html entities
      while matchdata = (text.match ESCAPE_RUN)
        length = matchdata.to_s.length
        char = ESCAPE_ENTITIES[matchdata.to_s[0]]
        text[(matchdata.begin(0))...(matchdata.end(0))] = char * length
      end
      text
    end

    def escape_emoji(text)
      while match = (text.match EMOJI)
        replace = match.to_s.tr(':_', '!=')
        text = text.gsub(match.to_s, replace)
      end
      text
    end

    def unescape_emoji(text)
      while match = (text.match ESCAPED_EMOJI)
        replace = match.to_s.tr('!=', ':_')
        text = text.gsub(match.to_s, replace)
      end
      text
    end
  end
end
