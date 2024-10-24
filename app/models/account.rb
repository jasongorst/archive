class Account < ApplicationRecord
  include Clearance::User

  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP

  validates :password,
            not_pwned: {
              threshold: 3,
              message: "has been pwned at least %{count} times",
              on_error: :invalid
            },
            on: [ :create, :update ]

  belongs_to :user, optional: true
  belongs_to :bot_user, optional: true

  def reset_password!
    generate_confirmation_token
    self.encrypted_password = "*"
    save validate: false

    AccountsMailer.reset_password(self).deliver_later
  end
end
