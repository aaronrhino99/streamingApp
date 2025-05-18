module Api
  module V1
    class PlaylistsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_playlist, only: [:show, :update, :destroy, :add_song, :remove_song]
      
      def index
        @playlists = current_user.playlists
        render json: @playlists
      end
      
      def show
        render json: @playlist, include: :songs
      end
      
      def create
        @playlist = current_user.playlists.new(playlist_params)
        
        if @playlist.save
          render json: @playlist, status: :created
        else
          render json: @playlist.errors, status: :unprocessable_entity
        end
      end
      
      def update
        if @playlist.update(playlist_params)
          render json: @playlist
        else
          render json: @playlist.errors, status: :unprocessable_entity
        end
      end
      
      def destroy
        @playlist.destroy
        head :no_content
      end
      
      # Add a song to playlist
      def add_song
        song = Song.find(params[:song_id])
        position = @playlist.playlist_songs.count + 1
        
        playlist_song = @playlist.playlist_songs.find_or_initialize_by(song: song)
        playlist_song.position = position unless playlist_song.persisted?
        
        if playlist_song.save
          render json: @playlist, include: :songs
        else
          render json: playlist_song.errors, status: :unprocessable_entity
        end
      end
      
      # Remove a song from playlist
      def remove_song
        song = Song.find(params[:song_id])
        playlist_song = @playlist.playlist_songs.find_by(song: song)
        
        if playlist_song&.destroy
          render json: @playlist, include: :songs
        else
          render json: { error: "Song not found in playlist" }, status: :not_found
        end
      end
      
      private
      
      def set_playlist
        @playlist = current_user.playlists.find(params[:id])
      end
      
      def playlist_params
        params.require(:playlist).permit(:name, :description)
      end
    end
  end
end