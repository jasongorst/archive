require_relative 'bot-server'

Dir[File.expand_path('initializers', __dir__) + '/*.rb'].sort.each do |file|
  require file
end

# remove slack-ruby-bot-server's Team in favor of Rails model
Object.send(:remove_const, :Team)
