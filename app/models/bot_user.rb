class BotUser < ApplicationRecord
  validates :slack_user, presence: true, uniqueness: true

  belongs_to :team
  has_one :account, required: false, dependent: :nullify
end
