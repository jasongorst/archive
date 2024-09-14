class Account < ApplicationRecord
  include Clearance::User

  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  validates :password, password_strength: true, on: [:create, :update]

  belongs_to :user, optional: true
  has_one :bot_user, dependent: :nullify
end
