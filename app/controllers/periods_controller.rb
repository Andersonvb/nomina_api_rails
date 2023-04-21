class PeriodsController < ApplicationController
  include RenderErrorJson

  before_action :set_period, only: [:show, :update, :destroy]
  before_action :set_companies

  def index
    @periods = Period.joins(:company).where(companies: {id: @companies.pluck(:id)})
  end

  def show
    if validate_user_id(@period.company.user_id)
      render :show, status: :ok
    else
      add_invalid_period_id_error

      render_error_json(@period, :unprocessable_entity)
    end
  end

  def create 
    @period = Period.new(period_params)

    valid_company_id = validate_company_id(@period.company_id)

    if valid_company_id && @period.save
      render :create, status: :ok
    else
      add_invalid_company_id_error unless valid_company_id

      render_error_json(@period, :unprocessable_entity)
    end
  end

  def update
    companies = Company.where(user_id: @current_user.id)

    if validate_company_id(@period.company_id) && validate_company_id(period_params[:company_id]) && @period.update(period_params)
      render :create, status: :ok
    else
      render_error_json(@period, :unprocessable_entity)
    end
  end

  def destroy
    if validate_company_id(@period.company_id)
      @period.destroy
      head :no_content
    else 
      add_invalid_period_id_error

      render_error_json(@period, :unprocessable_entity)
    end
  end

  private 

  def period_params
    params.require(:period).permit(:company_id, :start_date, :end_date)
  end

  def set_period
    @period = Period.find(params[:id])
  end

  def set_companies
    @companies = Company.user_companies(@current_user.id)
  end

  def validate_user_id(user_id)
    @current_user.id == user_id
  end

  def validate_company_id(company_id)
    @companies.pluck(:id).include?(company_id)
  end

  def add_invalid_period_id_error
    @period.errors.add(:base, I18n.t('activerecord.errors.models.period.base.not_valid_period_id'))
  end

  def add_invalid_company_id_error
    @period.errors.add(:company_id, I18n.t('activerecord.errors.models.period.company.not_valid_company_id'))
  end
end
