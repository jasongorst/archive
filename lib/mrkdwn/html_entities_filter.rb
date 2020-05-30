require 'rack/utils'

# wrapping escape_html from Rack::Utils
class HTMLEntitiesFilter
  class << self
    def convert(text)
      Rack::Utils.escape_html(text)
    end
  end
end