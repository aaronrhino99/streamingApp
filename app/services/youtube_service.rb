require 'net/http'
require 'json'
require 'uri'

class YoutubeService
  BASE_URL = "https://www.googleapis.com/youtube/v3"
  
  def initialize(api_key = nil)
    @api_key = api_key || ENV['YOUTUBE_API_KEY']
    raise "YouTube API key is missing" if @api_key.blank?
  end
  
  def search(query, max_results = 10)
    endpoint = "/search"
    params = {
      part: "snippet",
      q: query,
      maxResults: max_results,
      type: "video",
      key: @api_key
    }
    
    response = make_request(endpoint, params)
    return [] unless response["items"]
    
    video_ids = response["items"].map { |item| item["id"]["videoId"] }
    return [] if video_ids.empty?
    
    # Get video details for duration
    get_videos(video_ids)
  end
  
  def get_video(video_id)
    videos = get_videos([video_id])
    videos.first
  end
  
  private
  
  def get_videos(video_ids)
    endpoint = "/videos"
    params = {
      part: "snippet,contentDetails,statistics",
      id: video_ids.join(','),
      key: @api_key
    }
    
    response = make_request(endpoint, params)
    return [] unless response["items"]
    
    response["items"].map do |video|
      {
        youtube_id: video["id"],
        title: video["snippet"]["title"],
        artist: video["snippet"]["channelTitle"],
        thumbnail_url: video["snippet"]["thumbnails"]["high"]["url"],
        duration: parse_duration(video["contentDetails"]["duration"])
      }
    end
  end
  
  def make_request(endpoint, params)
    uri = URI.parse("#{BASE_URL}#{endpoint}")
    uri.query = URI.encode_www_form(params)
    
    response = Net::HTTP.get_response(uri)
    
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      Rails.logger.error "YouTube API Error: #{response.code} - #{response.body}"
      {}
    end
  rescue => e
    Rails.logger.error "Error making request to YouTube API: #{e.message}"
    {}
  end
  
  def parse_duration(iso8601_duration)
    # YouTube returns ISO 8601 duration format: PT1H2M34S
    # PT means "period time", H=hours, M=minutes, S=seconds
    hours = iso8601_duration[/(\d+)H/, 1].to_i
    minutes = iso8601_duration[/(\d+)M/, 1].to_i
    seconds = iso8601_duration[/(\d+)S/, 1].to_i
    
    hours * 3600 + minutes * 60 + seconds
  end
end
