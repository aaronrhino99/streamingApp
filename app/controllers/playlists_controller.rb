class PlaylistsController < ApplicationController
  # before_action :set_playlist, only: %i[show]
   # before_action :authenticate_user!

  def index
    render json: current_user.playlists
  end

  def show
    render json: @playlist, include: :songs
  end

  def create
    playlist = current_user.playlists.create!(playlist_params)
    render json: playlist, status: :created
  end

  private

  def set_playlist
    @playlist = current_user.playlists.find(params[:id])
  end

  def playlist_params
    params.require(:playlist).permit(:name)
  end
end