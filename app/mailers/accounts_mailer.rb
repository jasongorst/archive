class AccountsMailer < ApplicationMailer
  def reset_password(account)
    @account = account
    @url = url_for([ @account, :password, action: :edit, token: @account.confirmation_token ])

    mail(
      from: Clearance.configuration.mailer_sender,
      to: @account.email,
      subject: "Reset your password"
    )
  end
end
