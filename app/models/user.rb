class User < ApplicationRecord
  has_secure_password
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  
  has_many :songs, dependent: :destroy
  has_many :playlists, dependent: :destroy
  
  def generate_jwt
    JwtService.encode(user_id: id)
  end
end