module Api
  module V1
    class SongsController < BaseController
      before_action :set_song, only: %i[show update destroy stream]
      
      # GET /api/v1/songs
      def index
        songs = current_user.songs.order(created_at: :desc)
        render json: songs.map { |s| song_json(s) }, status: :ok
      end

      # GET /api/v1/songs/:id
      def show
        render json: song_json(@song), status: :ok
      end

      # POST /api/v1/songs
      # Kick off a background download/convert job
      def create
        song = current_user.songs.build(song_params.except(:audio_file))
        if song.save
          # youtube_id must be in song_params
          DownloadSongJob.perform_later(song.id, song_params[:youtube_id])
          render json: song_json(song), status: :accepted
        else
          render json: { errors: song.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/songs/:id
      def update
        if @song.update(song_params.except(:audio_file))
          render json: song_json(@song), status: :ok
        else
          render json: { errors: @song.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/songs/:id
      def destroy
        @song.destroy
        head :no_content
      end

      # GET /api/v1/songs/:id/stream
      def stream
        if @song.audio_file.attached?
          render json: {
            id:       @song.id,
            title:    @song.title,
            artist:   @song.artist,
            duration: @song.duration,
            url:      rails_blob_url(@song.audio_file, disposition: "inline"),
            status:   "ready"
          }, status: :ok
        else
          render json: {
            id:     @song.id,
            status: "processing"
          }, status: :ok
        end
      end

      private

      def set_song
        @song = current_user.songs.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Song not found" }, status: :not_found
      end

      private

      def song_params
        # Try nested params first, fall back to root level
        if params[:song].present?
          params.require(:song).permit(
            :title,
            :artist,
            :youtube_id,
            :duration,
            :thumbnail_url,
            :audio_file
          )
        else
          params.permit(
            :title,
            :artist,
            :youtube_id,
            :duration,
            :thumbnail_url,
            :audio_file
          )
        end
      end

      def song_json(song)
        {
          id:         song.id,
          title:      song.title,
          artist:     song.artist,
          youtube_id: song.youtube_id,
          duration:   song.duration,
          thumbnail:  song.thumbnail_url,
          status:     song.audio_file.attached? ? "ready" : "processing",
          audio_url:  song.audio_file.attached? ? rails_blob_url(song.audio_file, disposition: "inline") : nil,
          created_at: song.created_at.iso8601
        }
      end
    end
  end
end
