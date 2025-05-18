require 'tempfile'
require 'fileutils'

class DownloadConvertService
  def initialize(video_id:, user:)
    @video_id = video_id
    @user = user
  end

  def call
    title = fetch_title_from_youtube(@video_id)
    file_path = download_audio(@video_id)

    return nil unless File.exist?(file_path)

    song = @user.songs.create!(title: title, video_id: @video_id)
    song.audio_file.attach(io: File.open(file_path), filename: "#{title.parameterize}.mp3", content_type: 'audio/mpeg')

    File.delete(file_path) if File.exist?(file_path)
    song
  rescue => e
    Rails.logger.error "DownloadConvertService error: #{e.message}"
    nil
  end

  private

  def fetch_title_from_youtube(video_id)
    YoutubeService.new.get_video(video_id)&.dig(:title) || "Untitled"
  end

  def download_audio(video_id)
    output_path = Rails.root.join("tmp", "#{SecureRandom.hex}.mp3").to_s
    url = "https://www.youtube.com/watch?v=#{video_id}"

    system("yt-dlp", "-x", "--audio-format", "mp3", "-o", output_path, url)

    output_path
  end
end
