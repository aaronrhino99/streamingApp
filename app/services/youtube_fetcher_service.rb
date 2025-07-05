# app/services/youtube_fetcher_service.rb
require "net/http"
require "json"
require "cgi"

class YoutubeFetcherService
  BASE_URL = "https://www.googleapis.com/youtube/v3".freeze

  # Accept the API key via named parameter (with ENV default)
  def initialize(api_key: ENV.fetch("YOUTUBE_API_KEY"))
    @api_key = api_key
  end

  # Perform a search query, returning parsed JSON
  # max_results defaults to 25
  def search(query, max_results: 25)
    uri = URI.parse(
      "#{BASE_URL}/search" \
      "?part=snippet" \
      "&type=video" \
      "&maxResults=#{max_results}" \
      "&q=#{CGI.escape(query)}" \
      "&key=#{@api_key}"
    )

    res = Net::HTTP.get_response(uri)
    unless res.is_a?(Net::HTTPSuccess)
      raise "YouTube API error: #{res.code} #{res.message} — #{res.body}"
    end

    JSON.parse(res.body)
  end

  # Fetch detailed info for a single video
  def video_details(video_id)
    uri = URI.parse(
      "#{BASE_URL}/videos" \
      "?part=snippet,contentDetails" \
      "&id=#{CGI.escape(video_id)}" \
      "&key=#{@api_key}"
    )

    res = Net::HTTP.get_response(uri)
    unless res.is_a?(Net::HTTPSuccess)
      raise "YouTube API error: #{res.code} #{res.message} — #{res.body}"
    end

    JSON.parse(res.body)
  end
end
