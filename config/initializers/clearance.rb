Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = "reply@evilpaws.org"
  config.rotate_csrf_on_sign_in = true
  config.user_model = AdminUser
end
