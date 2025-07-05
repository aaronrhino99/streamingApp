# app/controllers/api/v1/search_controller.rb
module Api
  module V1
    class SearchController < ApplicationController
      # GET /api/v1/search?q=your_query
      def index
        query = params[:q].to_s.strip
        if query.empty?
          render json: { error: "Query parameter `q` is required" }, status: :bad_request
          return
        end

        # Call the service and extract the items array
        body = YoutubeFetcherService.new.search(query, max_results: 10)
        # The YouTube API returns a top-level "items" key
        results = body.fetch("items", []).map do |item|
          {
            video_id:      item.dig("id", "videoId"),
            title:         item.dig("snippet", "title"),
            thumbnail_url: item.dig("snippet", "thumbnails", "default", "url")
          }
        end

        render json: results
      rescue => e
        Rails.logger.error("YouTube search failed: #{e.message}")
        render json: { error: "Search error" }, status: :internal_server_error
      end
    end
  end
end
