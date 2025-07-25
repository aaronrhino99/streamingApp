Devise.setup do |config|
  config.mailer_sender = "please-change-me-at-config-initializers-devise@example.com"
  require "devise/orm/active_record"
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [ :http_auth ]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.navigational_formats = []
  config.sign_out_via = :delete
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  config.jwt do |jwt|
    jwt.secret = ENV["DEVISE_JWT_SECRET_KEY"] || Rails.application.credentials.secret_key_base
    jwt.dispatch_requests = [
      [ "POST", %r{^/users/sign_in$} ],
      [ "POST", %r{^/users$} ]
    ]
    jwt.revocation_requests = [
      [ "DELETE", %r{^/users/sign_out$} ]
    ]
    jwt.expiration_time = 3600.minutes.to_i
  end
end
