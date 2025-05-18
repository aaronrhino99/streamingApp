Rails.application.config.before_configuration do
  env_file = File.join(Rails.root, '.env')
  if File.exist?(env_file)
    require 'dotenv'
    Dotenv.load(env_file)
    
    # Log key presence (first 4 chars only) for debugging
    youtube_api_key = ENV['YOUTUBE_API_KEY']
    if youtube_api_key.present?
      truncated_key = youtube_api_key[0..3] + '...'
      Rails.logger.info "YouTube API Key loaded (starts with: #{truncated_key})"
    else
      Rails.logger.warn "YouTube API Key not found in environment variables"
    end
  end
end