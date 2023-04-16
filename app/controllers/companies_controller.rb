class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy]

  def index
    @companies = Company.where(user_id: @current_user.id)
  end

  def show
    if @current_user.companies.include?(@company)
      render :show, status: :ok
    else
      render json: { error: 'No company' }
    end
  end

  def create 
    @company = Company.new(company_params)

    if @current_user.id == company_params[:user_id] && @company.save
      render :create, status: :ok
    else
      render json: { error: 'error' }, status: :unprocessable_entity
    end
  end

  def update
    if @current_user.id == company_params[:user_id] && @current_user.companies.include?(Company.find(params[:id]))  && @company.update(company_params)
      render @company, status: :ok
    else
      render json: { error: 'error' }, status: :unprocessable_entity
    end
  end

  def destroy
    if @current_user.id == @company.user_id
      @company.destroy
      head :no_content
    else
      render json: { error: 'error' }
    end
  end

  private 

  def company_params
    params.require(:company).permit(:user_id, :name)
  end

  def set_company
    @company = Company.find(params[:id])
  end
end
