class Api::V1::ApplicationController < ::ApplicationController
  attr_reader :current_user 

  before_action :authenticate_request 

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    
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