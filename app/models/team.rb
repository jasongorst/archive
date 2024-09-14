class Team < ApplicationRecord
  attr_accessor :server # server at runtime
  SORT_ORDERS = ['created_at', '-created_at', 'updated_at', '-updated_at'].freeze

  validates :team_id, presence: true
  validates :token, presence: true, uniqueness: true

  has_many :bot_users

  scope :active, -> { where(active: true) }

  def self.purge!(dt = 2.weeks.ago)
    Team.where(active: false).where('updated_at <= ?', dt).each do |team|
      begin
        logger.info "Destroying #{team}, inactive since #{team.updated_at}."
        team.destroy
      rescue StandardError => e
        logger.warn "Error destroying #{team}, #{e.message}."
      end
    end
  end

  def deactivate!
    update!(active: false)
  end

  def activate!(token)
    update!(active: true, token: token)
  end

  def to_s
    {
      name: name,
      domain: domain,
      id: team_id
    }.map do |k, v|
      "#{k}=#{v}" if v
    end.compact.join(', ')
  end

  def ping!
    client = Slack::Web::Client.new(token: token)
    auth = client.auth_test

    presence = begin
                 client.users_getPresence(user: auth['user_id'])
               rescue Slack::Web::Api::Errors::MissingScope
                 nil
               end

    {
      auth: auth,
      presence: presence
    }
  end

  def ping_if_active!
    return unless active?

    ping!
  rescue Slack::Web::Api::Errors::SlackError => e
    logger.warn "Active team #{self} ping, #{e.message}."

    case e.message
    when 'account_inactive', 'invalid_auth'
      deactivate!
    end
  end
end
