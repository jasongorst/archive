# Preview all emails at http://localhost:3000/rails/mailers/passwords_mailer
class PasswordsMailerPreview < ActionMailer::Preview
  def reset_password
    PasswordsMailer.with(account: Account.find(3)).reset_password
  end
end
