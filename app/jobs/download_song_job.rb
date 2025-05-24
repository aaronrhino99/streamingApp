class DownloadSongJob < ApplicationJob
  queue_as :default

  def perform(song_id)
    song = Song.find(song_id)
    path = DownloadConvertService.call(song)

    if path && File.exist?(path)
      song.audio_file.attach(
        io: File.open(path),
        filename: File.basename(path),
        content_type: "audio/mpeg"
      )
      song.update!(status: :ready)
    else
      song.update!(status: :failed)
    end
  end
end
