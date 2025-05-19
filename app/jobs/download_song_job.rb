class DownloadSongJob < ApplicationJob
  queue_as :default

  def perform(song_id)
    song = Song.find(song_id)
    song.update!(status: :processing)

    file_path = DownloadConvertService.new(song.youtube_id).call
    song.audio_file.attach(io: File.open(file_path), filename: File.basename(file_path), content_type: "audio/mpeg")
    song.update!(status: :ready)
  rescue => e
    Rails.logger.error("Download failed: #{e.message}")
    song.update!(status: :failed) if song
  end
end