class Api::V1::AuthController < Api::V1::ApplicationController
  skip_before_action :authenticate_request, only: [:login, :signup] 

  def login
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id) 
      
      response.headers['Authorization'] = "Bearer #{token}"
      
      render json: { user: user_data(user) }, status: :ok 
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def signup
    user = User.new(user_params)

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      response.headers['Authorization'] = "Bearer #{token}"
      render json: { user: user_data(user) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_data(user)
    { 
      id: user.id, 
      name: user.name, 
      email: user.email,
    }
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end