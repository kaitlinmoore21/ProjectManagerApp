class Api::V1::UsersController < Api::V1::ApplicationController
  
  # GET /api/v1/profile
  # This action is implicitly protected because it inherits 
  # before_action :authenticate_request from Api::V1::ApplicationController.
  def show
    # Renders the profile of the user found via the JWT token (current_user)
    render json: user_data(current_user), status: :ok
  end

  # The 'create' (registration) method is handled by AuthController#signup.
  # Other actions like index/update/destroy are not typically needed here.

  private

  def user_data(user)
    # Define exactly what data to expose about the user (never expose password_digest)
    { id: user.id, name: user.name, email: user.email }
  end
  
  # user_params is no longer needed since 'create' has been moved.
end