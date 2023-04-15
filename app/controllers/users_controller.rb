class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request

  def index
    @users = User.order(:id)
  end

  def show; end

  def create 
    @user = User.new(user_params)

    if @user.save
      render :create, status: :ok
    else
      render @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render :create, status: :ok
    else
      render @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private 

  def user_params
    params.require(:user).permit(:name, :lastname, :username, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
