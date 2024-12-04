class FetchMissingPrivateMessagesJob < ApplicationJob
  queue_as :default

  OLDEST_DEFAULT = Time.new(2024, 11, 1)
  ACCOUNTS_DEFAULT = [ Account.find_by_email("jason@evilpaws.org") ]

  def perform(only_accounts: nil, oldest: nil)
    if Rails.env.development?
      only_accounts = ACCOUNTS_DEFAULT unless only_accounts
      oldest = OLDEST_DEFAULT unless oldest
    end

    # ensure emoji are up-to-date
    FetchEmojiJob.perform_now

    bot_users = if only_accounts
                  only_accounts.map(&:bot_user).compact
                else
                  Team.find_by_name("Firnost & Friends").bot_users.all
                end

    bot_users.each do |bot_user|
      connection = Slack::FetchMissingPrivateMessages.new(bot_user)
      channels = connection.fetch_channels
      connection.fetch_messages(channels, oldest: oldest)
    end
  end
end
