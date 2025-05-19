class PlaylistSong < ApplicationRecord
  belongs_to :playlist
  belongs_to :song

  validates :song_id, uniqueness: { scope: :playlist_id }
  default_scope { order(position: :asc, created_at: :asc) }
end
