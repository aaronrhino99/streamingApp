class Api::V1::SongsController < Api::V1::BaseController
  before_action :set_song, only: [:show, :update, :destroy]
  
  def index
    @songs = current_user.songs.recent
    render json: {
      songs: @songs.map do |song|
        {
          id: song.id,
          title: song.title,
          artist: song.artist,
          youtube_id: song.youtube_id,
          duration: song.duration,
          thumbnail_url: song.thumbnail_url,
          audio_file_url: song.audio_file.attached? ? song.audio_file_url : nil,
          created_at: song.created_at,
          updated_at: song.updated_at
        }
      end
    }
  end
  
  def show
    render json: {
      song: {
        id: @song.id,
        title: @song.title,
        artist: @song.artist,
        youtube_id: @song.youtube_id,
        duration: @song.duration,
        thumbnail_url: @song.thumbnail_url,
        audio_file_url: @song.audio_file.attached? ? @song.audio_file_url : nil,
        created_at: @song.created_at,
        updated_at: @song.updated_at
      }
    }
  end
  
  def create
    @song = current_user.songs.build(song_params)
    
    if @song.save
      #Enqueue the background job to download & convert the audion
      DownloadSongJob.perform_later(@song.id)
      render json: {
        message: 'Song created successfully',
        song: {
          id: @song.id,
          title: @song.title,
          artist: @song.artist,
          youtube_id: @song.youtube_id,
          duration: @song.duration,
          thumbnail_url: @song.thumbnail_url,
          audio_file_url: @song.audio_file.attached? ? @song.audio_file_url : nil,
          created_at: @song.created_at,
          updated_at: @song.updated_at
        }
      }, status: :created
    else
      render json: {
        errors: @song.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  def update
    if @song.update(song_params)
      render json: {
        message: 'Song updated successfully',
        song: {
          id: @song.id,
          title: @song.title,
          artist: @song.artist,
          youtube_id: @song.youtube_id,
          duration: @song.duration,
          thumbnail_url: @song.thumbnail_url,
          audio_file_url: @song.audio_file.attached? ? @song.audio_file_url : nil,
          created_at: @song.created_at,
          updated_at: @song.updated_at
        }
      }
    else
      render json: {
        errors: @song.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @song.destroy
    render json: {
      message: 'Song deleted successfully'
    }
  end
  
  private
  
  def set_song
    @song = current_user.songs.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Song not found' }, status: :not_found
  end
  
  def song_params
    params.require(:song).permit(:title, :artist, :youtube_id, :duration, :thumbnail_url, :audio_file)
  end
end



















