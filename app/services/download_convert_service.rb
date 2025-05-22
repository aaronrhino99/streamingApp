# app/services/download_convert_service.rb
require 'fileutils'
require 'active_support/core_ext/string/inflections' # For parameterize

class DownloadConvertService
  # Make sure this method is called with a Song object or sufficient data
  def self.call(song)
    # Ensure the Downloads/audion directory exists
    # Adjust 'Downloads/audion' if it's not directly under Rails.root
    # For user-specific directories, you'd make this dynamic (e.g., in a user's home directory)
    # But for a shared "downloads" area in the project, this path works.
    target_dir = Rails.root.join('Downloads', 'audio ')
    FileUtils.mkdir_p(target_dir) unless File.directory?(target_dir)

    # Sanitize the song title to be a valid filename
    # You might want to use song.title.parameterize or similar, or just the youtube_id
    # For uniqueness and simplicity, using youtube_id is often best, or a combination.
    # Let's use a parameterized title for a user-friendly filename, falling back to youtube_id.
    filename_base = song.title.present? ? song.title.parameterize(separator: '_') : song.youtube_id
    # Append youtube_id to ensure uniqueness in case of duplicate titles
    filename_base = "#{filename_base}_#{song.youtube_id}"

    # Construct the full output path
    output_path_template = File.join(target_dir.to_s, "#{filename_base}.%(ext)s")

    Rails.logger.info "yt-dlp output template: #{output_path_template}"

    begin
      video = YtDlp::Video.new(
        "https://www.youtube.com/watch?v=#{song.youtube_id}",
        extract_audio: true,
        audio_format: 'mp3',
        audio_quality: 0,
        output: output_path_template # Use the constructed path template
      )

      video.download

      # The `output_file` method will give the exact path with the resolved extension.
      actual_output_file = video.output_file

      if actual_output_file && File.exist?(actual_output_file) && File.size(actual_output_file) > 0
        Rails.logger.info "Successfully downloaded and converted #{song.youtube_id} to #{actual_output_file}"
        actual_output_file # Return the path to the downloaded file
      else
        Rails.logger.error "yt-dlp download failed for #{song.youtube_id}. No file found or file is empty."
        nil # Indicate failure
      end
    rescue YtDlp::Error => e
      Rails.logger.error "YtDlp error for #{song.youtube_id}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      nil
    rescue StandardError => e
      Rails.logger.error "Unexpected error during download for #{song.youtube_id}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      nil
    end
  end
end