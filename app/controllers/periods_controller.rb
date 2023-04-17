class PeriodsController < ApplicationController
  before_action :set_period, only: [:show, :update, :destroy]

  def index
    companies_id = Company.where(user_id: @current_user.id).map { |company| company.id }
    @periods = Period.where(company_id: companies_id)
  end

  def show
    if @current_user.id == @period.company.user_id
      render :show, status: :ok
    else
      render json: { error: 'No period' }
    end
  end

  def create 
    @period = Period.new(period_params)
    companies = Company.where(user_id: @current_user.id)

    if companies.any? { |company| company.id == @period.company_id } && @period.save
      render :create, status: :ok
    else
      render json: { error: 'error'}, status: :unprocessable_entity
    end
  end

  def update
    companies = Company.where(user_id: @current_user.id)

    if @period.company.user_id == @current_user.id && companies.any? { |company| company.id == period_params[:company_id] } && @period.update(period_params)
      render :create, status: :ok
    else
      render json: { error: 'error' }, status: :unprocessable_entity
    end
  end

  def destroy
    companies = Company.where(user_id: @current_user.id)

    if companies.any? { |company| company.id == @period.company_id }
      @period.destroy
      head :no_content
    else 
      render json: { error: 'error' }
    end
  end

  private 

  def period_params
    params.require(:period).permit(:company_id, :start_date, :end_date)
  end

  def set_period
    @period = Period.find(params[:id])
  end
end
