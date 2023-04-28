class PeriodsController < ApplicationController
  include RenderErrorJson

  before_action :set_period, only: [:show, :update, :destroy]
  before_action :set_user_companies
  before_action :validate_company_id, only: [:create, :update]
  before_action :validate_period_id, only: [:show, :update, :destroy]

  def index
    @periods = Period.joins(:company).where(companies: {id: @user_companies.pluck(:id)})
  end

  def show; end

  def create 
    @period = Period.new(period_params)

    if @period.save
      render :create, status: :created
    else
      render_error_json(@period, :unprocessable_entity)
    end
  end

  def update
    if @period.update(period_params)
      render :create, status: :ok
    else
      render_error_json(@period, :unprocessable_entity)
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

  def set_user_companies
    @user_companies = Company.user_companies(@current_user.id)
  end

  def validate_period_id
    render_record_not_found unless user_company?(@period.company_id)
  end

  def validate_company_id
    render_invalid_model_id(:company_id) unless user_company?(period_params[:company_id].to_i)
  end

  def user_company?(company_id)
    @user_companies.pluck(:id).include?(company_id)
  end
end
