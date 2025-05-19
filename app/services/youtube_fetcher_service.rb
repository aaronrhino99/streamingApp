class YoutubeFetcherService
  require "net/http"
  BASE_URL = "https://www.googleapis.com/youtube/v3".freeze

  def initialize(api_key: ENV.fetch("YOUTUBE_API_KEY"))
    @api_key = api_key
  end

  def search(query, max_results: 25)
    uri = URI.parse("#{BASE_URL}/search?part=snippet&type=video&maxResults=#{max_results}&q=#{CGI.escape(query)}&key=#{@api_key}")
    res = Net::HTTP.get_response(uri)
    raise "YouTube API error: #{res.body}" unless res.is_a?(Net::HTTPSuccess)

    JSON.parse(res.body)
  end

  def video_details(video_id)
    uri = URI.parse("#{BASE_URL}/videos?part=snippet,contentDetails&id=#{video_id}&key=#{@api_key}")
    res = Net::HTTP.get_response(uri)
    raise "YouTube API error: #{res.body}" unless res.is_a?(Net::HTTPSuccess)

    JSON.parse(res.body)
  end
end