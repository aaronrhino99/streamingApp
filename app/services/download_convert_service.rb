require 'tempfile'
require 'fileutils'

# app/services/download_convert_service.rb
class DownloadConvertService
  def self.call(youtube_id, output_dir: Rails.root.join('tmp'))
    video = YtDlp::Video.new(
      "https://www.youtube.com/watch?v=#{youtube_id}",
      extract_audio: true,
      audio_format: 'mp3',
      audio_quality: 0,
      output: "#{output_dir}/#{youtube_id}.%(ext)s"
    )
    video.download
    video.output_file # => path to MP3
  end
end
