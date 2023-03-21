Clearance.configure do |config|
  config.allow_sign_up = false
  config.routes = false
  config.mailer_sender = "admin@evilpaws.org"
  config.rotate_csrf_on_sign_in = true
  config.user_model = "AdminUser"
  config.redirect_url = "/admin"
  config.same_site = true
  config.secure_cookie = false
  config.signed_cookie = true
end
