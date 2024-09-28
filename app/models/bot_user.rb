class BotUser < ApplicationRecord
  validates :slack_user, presence: true, uniqueness: true

  belongs_to :team
  has_one :account, required: false, dependent: :nullify

  scope :active, -> { where(active: true) }

  def deactivate!
    update!(active: false)
  end

  def activate!(token)
    update!(active: true, user_access_token: token)
  end

  def to_s
    {
      display_name: display_name,
      slack_user: slack_user
    }.map do |k, v|
      "#{k}=#{v}" if v
    end.compact.join(', ')
  end
end
