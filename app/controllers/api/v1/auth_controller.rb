module Api
  module V1
    class AuthController < Api::V1::BaseController
      # Skip authentication only for public actions
      skip_before_action :authenticate_user!, only: %i[register login logout]
      
      # POST   /api/v1/auth/register
      def register
        user = User.new(user_params)
        if user.save
          token = JwtService.encode(user_id: user.id)
          render json: { 
            token: token, 
            user: user.as_json(except: [:password_digest]) 
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      # POST   /api/v1/auth/login
      def login
        # Handle both nested and flat parameter structures
        email = params[:email] || params.dig(:auth, :email)
        password = params[:password] || params.dig(:auth, :password)
        
        user = User.find_by(email: email)
        
        if user&.authenticate(password)
          token = JwtService.encode(user_id: user.id)
          render json: { 
            token: token, 
            user: user.as_json(except: [:password_digest]) 
          }, status: :ok
        else
          render json: { message: 'Invalid credentials' }, status: :unauthorized
        end
      end
      
      # DELETE /api/v1/auth/logout
      def logout
        # If using a blacklist strategy, revoke the token here
        render json: { message: 'Logged out' }, status: :ok
      end
      # GET /api/v1/auth/profile
      def profile
        render json: current_user.slice(:id, :email), status: :ok
      end
      
      private
      
      def user_params
        # Handle both nested and flat parameter structures
        if params[:auth].present?
          params.require(:auth).permit(:email, :password, :password_confirmation)
        else
          params.permit(:email, :password, :password_confirmation)
        end
      end
    end
  end
end