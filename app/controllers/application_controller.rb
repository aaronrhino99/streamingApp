class ApplicationController < ActionController::API
  # Remove the global before_action since your API controllers handle auth individually
  # before_action :authenticate_user!, except: [:health_check]
  
  private
  
  def authenticate_user!
    token = extract_token
    return render_unauthorized unless token
    decoded_token = JwtService.decode(token)
    return render_unauthorized unless decoded_token
    @current_user = User.find_by(id: decoded_token[:user_id])
    return render_unauthorized unless @current_user
  end
  
  def current_user
    @current_user
  end
  
  def extract_token
    header = request.headers['Authorization']
    return nil unless header
    
    # Expected format: "Bearer <token>"
    token = header.split(' ').last
    return nil if token.blank?
    
    token
  end
  
  def render_unauthorized
    render json: {
      message: 'Unauthorized. Please provide a valid token.'
    }, status: :unauthorized
  end
  
  def health_check
    render json: {
      message: 'API is running',
      timestamp: Time.current
    }, status: :ok
  end
end