class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers

  before_action :authenticate_user!, unless: -> { Rails.env.development? && request.path.start_with?("/sidekiq") }

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render json: { error: "Not Found" }, status: :not_found
  end
end