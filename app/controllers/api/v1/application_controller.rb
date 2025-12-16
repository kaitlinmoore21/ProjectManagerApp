class Api::V1::ApplicationController < ::ApplicationController
  # Include Pagy functionality for use in all API controllers (like TasksController)
  # include Pagy::Backend
  attr_reader :current_user 

  before_action :authenticate_request 

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    # NOTE: You must ensure JsonWebToken class is available (in lib/json_web_token.rb)
    @decoded = JsonWebToken.decode(header)
    
    if @decoded && @decoded[:user_id]
        @current_user = User.find(@decoded[:user_id])
    end

    unless @current_user
      render json: { error: 'Not Authorized (Invalid or missing token)' }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
      render json: { error: 'Not Authorized (User not found)' }, status: :unauthorized
  end
end