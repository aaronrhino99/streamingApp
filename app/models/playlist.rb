class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_songs, -> { order(position: :asc) }, dependent: :destroy
  has_many :songs, through: :playlist_songs
  
  validates :name, presence: true
end