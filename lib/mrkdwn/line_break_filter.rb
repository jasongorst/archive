class LineBreakFilter
  BREAK_TAG = '<br>'
  class << self
    def convert(text)
      text.gsub(/\n/,BREAK_TAG)
    end
  end
end