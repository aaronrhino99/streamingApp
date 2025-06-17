
Devise.setup do |config|
  # The e-mail address that will be shown in Devise::Mailer
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # Load and configure the ORM. Supports :active_record (default) and :mongoid
  require 'devise/orm/active_record'

  # Case-insensitive keys (default: [:email])
  config.case_insensitive_keys = [:email]

  # Strip whitespace from these keys (default: [:email])
  config.strip_whitespace_keys = [:email]

  # Skip session storage for HTTP Auth (we’re JWT-only)
  config.skip_session_storage = [:http_auth]

  # Turn off HTTP Basic auth entirely
  config.http_authenticatable = false

  # How many times to hash the password. Default is 12 for non-test envs.
  config.stretches = Rails.env.test? ? 1 : 12

  # Require any email changes to be confirmed (default: true)
  config.reconfirmable = true

  # Password length
  config.password_length = 6..128

  # Email format regex
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # Reset password within this time frame
  config.reset_password_within = 6.hours

  # What formats should be treated as navigational
  config.navigational_formats = []

  # HTTP method to sign out
  config.sign_out_via = :delete

  # Responder status codes
  config.responder.error_status    = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # ==> JWT configuration
  config.jwt do |jwt|
    # Use your secret key from environment
    jwt.secret = ENV['DEVISE_JWT_SECRET_KEY']

    # Issue a token only on sign_in
    jwt.dispatch_requests = [
      ['POST', %r{^/users/sign_in$}],
      # Optionally issue on sign_up:
      # ['POST', %r{^/users$}]
    ]

    # Revoke token on sign_out
    jwt.revocation_requests = [
      ['DELETE', %r{^/users/sign_out$}]
    ]

    # Token expiration (in seconds)
    jwt.expiration_time = 15.minutes.to_i
  end
end
