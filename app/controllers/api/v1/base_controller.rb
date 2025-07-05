module Api
  module V1
    class BaseController < ApplicationController
      # Skip CSRF protection for API requests
      # skip_before_action :verify_authenticity_token
      
      # Set up authentication
      before_action :authenticate_user!
      
      # Handle common errors
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
      
      private
      
      def authenticate_user!
        token = request.headers['Authorization']&.split(' ')&.last
        return unauthorized unless token
        
        decoded = JwtService.decode(token)
        @current_user = User.find(decoded[:user_id])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        unauthorized
      end
      
      def current_user
        @current_user
      end
      
      def unauthorized
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
      
      def not_found
        render json: { error: 'Not found' }, status: :not_found
      end
      
      def unprocessable_entity(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end