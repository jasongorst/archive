Clearance.configure do |config|
  config.allow_sign_up = false
  config.allow_password_reset = true
  config.routes = false
  config.mailer_sender = "admin@evilpaws.org"
  config.rotate_csrf_on_sign_in = true
  config.user_model = "Account"
  config.redirect_url = "/"
  config.same_site = true
  config.signed_cookie = true
end
