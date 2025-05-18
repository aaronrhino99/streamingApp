class JwtBlacklist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JwtBlacklist

  self.table_name = 'jwt_blacklists'
end