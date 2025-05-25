class User < ApplicationRecord
# Include default devise modules.
  # devise :database_authenticatable, :registerable,
  #        :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  # sinclude DeviseTokenAuth::Concerns::User

  has_many :songs, dependent: :destroy
  has_many :playlists, dependent: :destroy
end