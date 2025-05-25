# app/controllers/search_controller.rb
class SearchController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:index]  # if you lock down auth elsewhere

  def index
    return render json: [], status: :bad_request if params[:q].blank?

    raw = YoutubeFetcherService.new.search(params[:q])
    items = raw.fetch("items", []).map do |item|
      {
        video_id:      item.dig("id", "videoId"),
        title:         item.dig("snippet", "title"),
        thumbnail_url: item.dig("snippet", "thumbnails", "default", "url")
      }
    end

    render json: items
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
