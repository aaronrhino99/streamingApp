class SongsController < ApplicationController
  before_action :set_song, only: %i[show update stream]

  # GET /songs
  def index
    @songs = current_user ? current_user.songs.recent : Song.none
    render json: @songs
  end

  # GET /songs/:id
  def show
    render json: @song
  end

  # POST /songs
  def create
    @song = current_user.songs.create!(song_params.merge(status: :queued))
    DownloadSongJob.perform_later(@song.id)
    render json: @song, status: :accepted
  end

  # PATCH /songs/:id
  def update
    if @song.update(song_params)
      render json: @song
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # GET /songs/:id/stream
  def stream
    if @song.ready? && @song.audio_file.attached?
      url = @song.audio_file.url(expires_in: 15.minutes, disposition: "inline")
      render json: { url: url }
    else
      head :accepted
    end
  end

  private

  def set_song
    @song = current_user.songs.find(params[:id])
  end

  def song_params
    params.require(:song).permit(:youtube_id, :favorite)
  end
end

