class PeriodsController < ApplicationController
  before_action :set_period, only: [:show, :update, :destroy]

  def index
    @periods = Period.order(:id)
  end

  def show; end

  def create 
    @period = Period.new(period_params)

    if @period.save
      render :create, status: :ok
    else
      render @period.errors, status: :unprocessable_entity
    end
  end

  def update
    if @period.update(period_params)
      render :create, status: :ok
    else
      render @period.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @period.destroy
    head :no_content
  end

  private 

  def period_params
    params.require(:period).permit(:company_id, :start_date, :end_date)
  end

  def set_period
    @period = Period.find(params[:id])
  end
end
