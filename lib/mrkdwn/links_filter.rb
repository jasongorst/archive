class LinksFilter
  # TODO: this has to handle slack user/channel links as well
  # NOTE: if we call this either before or after html entities, it will break something

  LINK = /\<(?=\S)(.+?)(?<=\S)\>/
  LINK_HTML = '<a href="\1">\1</a>'
  class << self
    def convert(text)
      text.gsub(LINK, LINK_HTML)
    end
  end
end