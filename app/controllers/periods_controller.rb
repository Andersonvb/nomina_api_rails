class PeriodsController < ApplicationController
  include RenderErrorJson

  before_action :set_period, only: [:show, :update, :destroy]
  before_action :validate_company_owner, only: [:create, :update]
  before_action :validate_period_owner, only: [:show, :update, :destroy]

  def index
    user_companies = Company.user_companies(@current_user.id)

    @periods = Period.joins(:company).where(companies: {id: user_companies.pluck(:id)})
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

  def validate_company_owner
    company = Company.find(period_params[:company_id])

    render_invalid_id_error(:company_id) unless belongs_to_current_user?(company)
  end

  def validate_period_owner
    render_record_not_found unless belongs_to_current_user?(@period.company)
  end

  def belongs_to_current_user?(company)
    company.user == @current_user
  end
end
