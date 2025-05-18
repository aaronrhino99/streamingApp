# app/controllers/api/v1/search_controller.rb
module Api::V1
  class SearchController < ApplicationController

    def youtube_search
  query = params[:query]

  if query.blank?
    render json: { error: 'Query parameter is required' }, status: :bad_request
    return
  end

  begin
    service = YoutubeService.new
    results = service.search(query)
    render json: { results: results }
  rescue => e
    Rails.logger.error "YouTube search error: #{e.message}"
    render json: { error: "Could not complete search", details: e.message }, status: :service_unavailable
  end
end

  end
end
