SlackRubyBotServer.configure do |config|
  config.service_class = BotServer::Service
  config.oauth_version = :v2

  config.oauth_scope = %w[
    channels:history
    channels:join
    channels:read
    chat:write
    emoji:read
    files:read
    users:read
  ]

  stdout_logger = Logger.new(STDOUT, level: Logger::DEBUG)
  file_logger = Logger.new("log/#{ENV['RACK_ENV']}.log", level: Logger::INFO)
  config.logger = ActiveSupport::BroadcastLogger.new(stdout_logger, file_logger)

  config.view_paths = File.expand_path(File.join(__dir__, '../public'))
end
