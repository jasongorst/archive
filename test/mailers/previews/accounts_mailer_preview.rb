# Preview all emails at http://localhost:3000/rails/mailers/passwords_mailer
class AccountsMailerPreview < ActionMailer::Preview
  def reset_password
    AccountsMailer.reset_password(Account.find(8))
  end
end
