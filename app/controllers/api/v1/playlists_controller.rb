module Api
  module V1
    class AuthController < ApplicationController

      before_action :set_playlist, only: [:show, :update, :destroy]
      
      def index
        @playlists = current_user.playlists.order(created_at: :desc)
        render json: {
          playlists: @playlists.map do |playlist|
            {
              id: playlist.id,
              name: playlist.name,
              description: playlist.description,
              songs_count: playlist.songs.count,
              created_at: playlist.created_at,
              updated_at: playlist.updated_at
            }
          end
        }
      end
      
      def show
        render json: {
          playlist: {
            id: @playlist.id,
            name: @playlist.name,
            description: @playlist.description,
            songs: @playlist.songs.map do |song|
              {
                id: song.id,
                title: song.title,
                artist: song.artist,
                youtube_id: song.youtube_id,
                duration: song.duration,
                thumbnail_url: song.thumbnail_url,
                audio_file_url: song.audio_file.attached? ? song.audio_file_url : nil
              }
            end,
            created_at: @playlist.created_at,
            updated_at: @playlist.updated_at
          }
        }
      end
      
      def create
        @playlist = current_user.playlists.build(playlist_params)
        
        if @playlist.save
          render json: {
            message: 'Playlist created successfully',
            playlist: {
              id: @playlist.id,
              name: @playlist.name,
              description: @playlist.description,
              songs_count: 0,
              created_at: @playlist.created_at,
              updated_at: @playlist.updated_at
            }
          }, status: :created
        else
          render json: {
            errors: @playlist.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
      
      def update
        if @playlist.update(playlist_params)
          render json: {
            message: 'Playlist updated successfully',
            playlist: {
              id: @playlist.id,
              name: @playlist.name,
              description: @playlist.description,
              songs_count: @playlist.songs.count,
              created_at: @playlist.created_at,
              updated_at: @playlist.updated_at
            }
          }
        else
          render json: {
            errors: @playlist.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
      
      def destroy
        @playlist.destroy
        render json: {
          message: 'Playlist deleted successfully'
        }
      end
      
      private
      
      def set_playlist
        @playlist = current_user.playlists.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Playlist not found' }, status: :not_found
      end
      
      def playlist_params
        params.require(:playlist).permit(:name, :description)
      end
    end
  end
end













