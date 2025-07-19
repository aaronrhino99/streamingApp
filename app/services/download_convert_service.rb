require 'fileutils'
require 'securerandom'
require 'open3'


class DownloadConvertService
  def self.call(song)
    youtube_id = song.youtube_id
    
    target_dir = Rails.root.join('Downloads', 'audio')
    FileUtils.mkdir_p(target_dir)

    filename_base = song.title.present? ? song.title.parameterize(separator: '_') : youtube_id
    filename_base = "#{filename_base}_#{SecureRandom.hex(4)}"
    output_path = File.join(target_dir, "#{filename_base}.mp3")

    Rails.logger.info "Starting download for YouTube ID: #{youtube_id}"
    Rails.logger.info "Output path: #{output_path}"

    begin
      # First check if yt-dlp is installed
      stdout, stderr, status = Open3.capture3('which yt-dlp')
      
      if !status.success?
        Rails.logger.error "yt-dlp not found. Please install with: brew install yt-dlp"
        return nil
      end

      # Use direct system call instead of Ruby gem
      youtube_url = "https://www.youtube.com/watch?v=#{youtube_id}"
      
      cmd = [
        'yt-dlp',
        '--extract-audio',
        '--audio-format', 'mp3',
        '--audio-quality', '0',
        '--output', output_path.sub('.mp3', '.%(ext)s'),
        youtube_url
      ]

      Rails.logger.info "Running command: #{cmd.join(' ')}"
      
      stdout, stderr, status = Open3.capture3(*cmd)
      
      if status.success?
        Rails.logger.info "Download successful"
        Rails.logger.info "STDOUT: #{stdout}"
        
        # Check if file exists and return the path (don't attach here)
        if File.exist?(output_path)
          Rails.logger.info "File found at: #{output_path}"
          return output_path
        else
          Rails.logger.error "File not found after download: #{output_path}"
          return nil
        end
      else
        Rails.logger.error "Download failed with exit code: #{status.exitstatus}"
        Rails.logger.error "STDERR: #{stderr}"
        return nil
      end
      
    rescue => e
      Rails.logger.error "Download failed with exception: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      return nil
    end
  end
end