class UnescapeSpecial
  class << self
    def convert(text)
      unescape_special(text)
    end

    def unescape_special(text)
      text.gsub(/&#42;/, '*')
          .gsub(/&#95;/, '_')
          .gsub(/&#126;/, '~')
          .gsub(/&#58;/, ':')
    end
  end
end
