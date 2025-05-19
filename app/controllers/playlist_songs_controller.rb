class PlaylistSongsController < ApplicationController
  def create
    playlist = current_user.playlists.find(params[:playlist_id])
    song     = current_user.songs.find(params[:song_id])
    playlist.playlist_songs.create!(song: song)
    head :created
  end
end