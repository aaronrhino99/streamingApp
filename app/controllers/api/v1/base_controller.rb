module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

      private

      def authenticate_user!
        token = request.headers["Authorization"]&.split(" ")&.last
        decoded = JwtService.decode(token)
        if decoded && decoded[:user_id]
          @current_user = User.find(decoded[:user_id])
        else
          render_unauthorized("Invalid or missing token")
        end
      rescue JWT::DecodeError => e
        render_unauthorized("JWT Decode Error: #{e.message}")
      rescue ActiveRecord::RecordNotFound
        render_unauthorized("User not found")
      end

      def render_unauthorized(message = "Unauthorized")
        render json: { error: message }, status: :unauthorized
      end

      def current_user
        @current_user
      end

      def not_found
        render json: { error: "Not found" }, status: :not_found
      end

      def unprocessable_entity(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
