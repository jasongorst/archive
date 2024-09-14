class User < ApplicationRecord
  validates :slack_user, :display_name, presence: true

  has_many :messages, -> { order(posted_at: :asc) }
  has_many :private_messages, -> { order(posted_at: :asc) }
  has_and_belongs_to_many :private_channels
  has_one :account, required: false
end
