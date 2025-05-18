class Song < ApplicationRecord
  belongs_to :user
  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs
  
  has_one_attached :audio_file
  
  validates :title, presence: true
  validates :youtube_id, presence: true, uniqueness: true
end