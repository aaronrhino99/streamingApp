# app/controllers/api/v1/songs_controller.rb
module Api::V1
  class SongsController < ApplicationController
    before_action :authenticate_user!

    def index
      songs = current_user.songs.with_attached_audio_file
      render json: songs.map { |s| serialize_song(s) }
    end

    def create
      video_id = params[:video_id]
      return render json: { error: "Missing video_id" }, status: :bad_request if video_id.blank?

      DownloadSongJob.perform_later(video_id, current_user.id)
      render json: { message: "Download started" }, status: :accepted
    end

    private

    def serialize_song(song)
      {
        id: song.id,
        title: song.title,
        video_id: song.video_id,
        audio_url: url_for(song.audio_file)
      }
    end
  end
end
