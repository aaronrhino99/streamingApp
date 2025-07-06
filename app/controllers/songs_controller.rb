# # app/controllers/songs_controller.rb
# class SongsController < ApplicationController
#   # before_action :authenticate_user!
#   # before_action :set_song, only: %i[show update download stream destroy]
#   # skip_before_action :authenticate_user!, only: [:create, :index]  # for dev/testing


#   # GET /songs
#   # List all songs belonging to the current user
#   def index
#     # songs = current_user.songs.with_attached_audio_file
#     # render json: songs.map { |song| song_json(song) }, status: :ok

#     # Testing cout the download feature
#     render json: Song.all.with_attached_audio_file.map { |song|
#        song.as_json.merge(audio_file_url: url_for(song.audio_file))
#      }

#   end

#   # GET /songs/:id
#   # Show a single song’s metadata (not the raw audio)
#   def show
#     render json: song_json(@song), status: :ok
#   end

#   # POST /songs
#   # Enqueue a download job for a new YouTube video
#   def create
#   #   song = current_user.songs.create!(build_song_params.merge(status: :queued))
#   #   DownloadSongJob.perform_later(song.id)
#   #   render json: song_json(song), status: :accepted
#   # rescue ActiveRecord::RecordInvalid => e
#   #   render_error(e.record.errors.full_messages, :unprocessable_entity)

#      song = Song.create!(build_song_params)
#      DownloadSongJob.perform_later(song.id)
#      render json: song, status: :created
#   end

#   # POST /songs/:id/download
#   # Re-queue an existing song for download
#   def download
#     @song.update!(status: :queued)
#     DownloadSongJob.perform_later(@song.id)
#     render json: { message: "Download re-started" }, status: :accepted
#   end

#   # GET /songs/:id/stream
#   # Return a temporary public URL for streaming the MP3
#   def stream
#     if @song.ready? && @song.audio_file.attached?
#       url = @song.audio_file.service_url(disposition: "inline", expires_in: 15.minutes)
#       render json: { url: url }, status: :ok
#     else
#       render json: { status: @song.status }, status: :accepted
#     end
#   end

#   # PATCH/PUT /songs/:id
#   # Allow updating metadata (e.g., marking favorite)
#   def update
#     @song.update!(update_song_params)
#     render json: song_json(@song), status: :ok
#   rescue ActiveRecord::RecordInvalid => e
#     render_error(e.record.errors.full_messages, :unprocessable_entity)
#   end

#   # DELETE /songs/:id
#   # Remove a song (and its blob) from the user’s library
#   def destroy
#     @song.destroy
#     head :no_content
#   end

#   private

#   # Find the song scoped to current_user
#   def set_song
#     @song = current_user.songs.find(params[:id])
#   rescue ActiveRecord::RecordNotFound
#     render_error("Song not found", :not_found)
#   end

#   # Build params for creating a new song
#   def build_song_params
#     p = params.require(:song).permit(:title, :video_id, :thumbnail_url)
#     # map video_id → youtube_id if your DB column is named youtube_id
#     p[:youtube_id] = p.delete(:video_id)
#     p
#   end

#   # Permit only updatable fields
#   def update_song_params
#     params.require(:song).permit(:title, :favorite)
#   end

#   # Standardized JSON payload for a song
#   def song_json(song)
#     {
#       id:            song.id,
#       title:         song.title,
#       youtube_id:    song.youtube_id,
#       thumbnail_url: song.thumbnail_url,
#       status:        song.status,
#       favorite:      song.favorite,
#       created_at:    song.created_at,
#       updated_at:    song.updated_at,
#       audio_file_url: song.audio_file.attached? ? 
#         Rails.application.routes.url_helpers.rails_blob_path(song.audio_file, only_path: true) :
#         nil
#     }
#   end

#   # Render uniform error messages
#   def render_error(messages, status)
#     render json: { errors: Array(messages) }, status: status
#   end
# end
