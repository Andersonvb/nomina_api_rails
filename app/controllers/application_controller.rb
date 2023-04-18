class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_user

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last

    decoded = jwt_decode(token)
    
    @current_user = User.find(decoded[:user_id])
  end
end
