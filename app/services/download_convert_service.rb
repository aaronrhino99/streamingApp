require 'fileutils'
require 'securerandom'

class DownloadConvertService
  def self.call(song)
    target_dir = Rails.root.join('Downloads', 'audio')
    FileUtils.mkdir_p(target_dir)

    filename_base = song.title.present? ? song.title.parameterize(separator: '_') : song.youtube_id
    filename_base = "#{filename_base}_#{SecureRandom.hex(4)}"
    output_path_template = File.join(target_dir, "#{filename_base}.%(ext)s")

    Rails.logger.info "yt-dlp output template: #{output_path_template}"

    begin
      video = YtDlp::Video.new(
        "https://www.youtube.com/watch?v=#{song.youtube_id}",
        extract_audio: true,
        audio_format: 'mp3',
        audio_quality: 0,
        output: output_path_template
      )

      video.download

      # Try to find the actual file path (assume mp3 if it succeeded)
      final_path = output_path_template.sub('%(ext)s', 'mp3')
      if File.exist?(final_path)
        Rails.logger.info "Download successful: #{final_path}"
        return final_path
      else
        Rails.logger.warn "File not found after download: #{final_path}"
        return nil
      end
    rescue => e
      Rails.logger.error "Download failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      return nil
    end
  end
end
