class SearchController < ApplicationController
  skip_before_action :authenticate_user!

  def index

    query = params[:q].to_s.strip
    return render json: [] if query.blank?

    results = YoutubeFetcherService.new.search(query)
    render json: results
  end
end