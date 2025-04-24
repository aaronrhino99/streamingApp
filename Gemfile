source "https://rubygems.org"

# Core Rails
gem "rails", "~> 8.0.2"
gem "pg", "~> 1.1"                  # PostgreSQL database
gem "puma", ">= 5.0"                # Web server
gem "bootsnap", require: false      # Speeds up boot time

# API & Authentication
gem "devise"                        # User authentication
gem "devise-jwt"                    # JWT tokens for API auth
gem "rack-cors"                     # Cross-origin request support

# Background Processing
gem "sidekiq"                       # Background job processing
gem "redis"                         # Required for Sidekiq

# YouTube Integration
gem "google-api-client", "~> 0.53.0" # YouTube API
gem "yt-dlp.rb"                     # For yt-dlp integration
gem "down"                          # For downloading files

# Utilities
gem "acts_as_list"                  # For playlist item ordering
gem "dotenv-rails"                  # Environment variables
gem "tzinfo-data", platforms: %i[windows jruby] # Timezone info

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
end


