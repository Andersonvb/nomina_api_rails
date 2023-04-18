class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]

  def create
    user = User.find_by(username: params[:username])

    if user && user&.authenticate(params[:password])
      token = jwt_encode(user_id: user.id)

      render json: { token: token }, status: :ok
    else
      render json: { error: 'Username or password not valid' }, status: :unauthorized
    end
  end
end
