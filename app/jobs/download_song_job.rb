# app/jobs/download_song_job.rb
class DownloadSongJob < ApplicationJob
  queue_as :default
  
  def perform(song_id, youtube_id)
    song = Song.find(song_id)
    
    # Update status to downloading
    song.update!(download_status: 'downloading')
    
    # Call the service with just the song object (matching the service signature)
    file_path = DownloadConvertService.call(song)
    
    if file_path && File.exist?(file_path)
      # Attach the MP3 to the song record
      song.audio_file.attach(
        io:           File.open(file_path),
        filename:     File.basename(file_path),
        content_type: "audio/mpeg"
      )
      
      # Update metadata on the model
      song.update!(
        download_status: 'completed',
        status: :ready
      )
      
      Rails.logger.info "Successfully downloaded and attached audio for Song##{song_id}"
    else
      song.update!(download_status: 'failed', status: :failed)
      Rails.logger.error "Download failed for Song##{song_id} - no file path returned"
    end
    
  rescue StandardError => e
    Rails.logger.error("DownloadSongJob failed for Song##{song_id}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    song&.update!(download_status: 'failed', status: :failed)
  end
end