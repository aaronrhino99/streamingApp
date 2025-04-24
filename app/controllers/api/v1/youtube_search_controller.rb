class Api::V1::YoutubeSearchController < ApplicationController
  before_action :authenticate_user!
  
  def search
    query = params[:query]
    if query.present?
      service = YoutubeFetcherService.new
      results = service.search(query)
      render json: { results: results }
    else
      render json: { error: "Query parameter is required" }, status: :bad_request
    end
  end
  
  def show
    video_id = params[:id]
    if video_id.present?
      service = YoutubeFetcherService.new
      details = service.get_video_details(video_id)
      if details
        render json: { video: details }
      else
        render json: { error: "Video not found" }, status: :not_found
      end
    else
      render json: { error: "Video ID parameter is required" }, status: :bad_request
    end
  end
end