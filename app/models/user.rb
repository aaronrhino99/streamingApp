
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         # :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist
  has_many :songs, dependent: :destroy
  has_many :playlists, dependent: :destroy
  
  validates :username, presence: true, uniqueness: true
end