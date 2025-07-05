# app/controllers/api/v1/users_controller.rb
class Api::V1::UsersController < Api::V1::BaseController
  def create
    user = User.new(user_params)
    
    if user.save
      render json: {
        message: "User created successfully",
        user: user_response(user)
      }, status: :created
    else
      render json: {
        error: "User creation failed",
        messages: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end

  def user_response(user)
    {
      id: user.id,
      email: user.email,
      name: user.name,
      created_at: user.created_at
    }
  end
end