require 'net/http'
require 'json'

class YoutubeFetcherService
  BASE_URL = "https://www.googleapis.com/youtube/v3"
  
  def initialize(api_key = ENV['YOUTUBE_API_KEY'])
    @api_key = api_key
  end
  
  def search(query, max_results = 10)
    url = URI("#{BASE_URL}/search?part=snippet&q=#{URI.encode_www_form_component(query)}&maxResults=#{max_results}&type=video&key=#{@api_key}")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    
    return [] if data['items'].nil?
    
    data['items'].map do |item|
      {
        youtube_id: item['id']['videoId'],
        title: item['snippet']['title'],
        thumbnail_url: item['snippet']['thumbnails']['high']['url'],
        published_at: item['snippet']['publishedAt'],
        channel_title: item['snippet']['channelTitle']
      }
    end
  end
  
  def get_video_details(video_id)
    url = URI("#{BASE_URL}/videos?part=snippet,contentDetails&id=#{video_id}&key=#{@api_key}")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    
    return nil if data['items'].empty?
    
    item = data['items'].first
    {
      youtube_id: item['id'],
      title: item['snippet']['title'],
      description: item['snippet']['description'],
      thumbnail_url: item['snippet']['thumbnails']['high']['url'],
      channel_title: item['snippet']['channelTitle'],
      duration: item['contentDetails']['duration'], # ISO 8601 format
      published_at: item['snippet']['publishedAt']
    }
  end
end