class PayrollsController < ApplicationController
  include RenderErrorJson

  before_action :set_payroll, only: [:show, :update, :destroy]
  before_action :set_companies

  def index
    periods = Period.joins(:company).where(companies: {id: @companies.pluck(:id)})

    @payrolls = Payroll.where(period_id: periods.pluck(:id))
  end

  def show
    if validate_company_id(@payroll.period.company_id)
      render :show, status: :ok
    else
      add_invalid_payroll_id_error

      render_error_json(@payroll, :unprocessable_entity)
    end
  end

  def create 
    @payroll = Payroll.new(payroll_params)

    if validate_company_id(@payroll.period.company_id) && validate_company_id(@payroll.employee.company_id) && @payroll.save
      render :create, status: :ok
    else
      render_error_json(@payroll, :unprocessable_entity)
    end
  end

  def update
    if validate_company_id(Period.find(payroll_params[:period_id]).company_id) && validate_company_id(Period.find(payroll_params[:employee_id]).company_id) && validate_company_id(@payroll.period.company_id) && @payroll.update(payroll_params)
      render :create, status: :ok
    else
      render_error_json(@payroll, :unprocessable_entity)
    end
  end

  def destroy
    if validate_company_id(@payroll.period.company_id)
      @payroll.destroy
      head :no_content
    else
      add_invalid_payroll_id_error

      render_error_json(@payroll, :unprocessable_entity)
    end
  end

  private 

  def payroll_params
    params.require(:payroll).permit(:employee_id, :period_id, :salary_income, :non_salary_income, :deductions, :transport_allowance, :net_pay)
  end

  def set_payroll
    @payroll = Payroll.find(params[:id])
  end

  def set_companies
    @companies = Company.user_companies(@current_user.id)
  end

  def validate_company_id(company_id)
    @companies.pluck(:id).include?(company_id)
  end

  def add_invalid_payroll_id_error
    @payroll.errors.add(:base, I18n.t('activerecord.errors.models.payroll.base.not_valid_payroll_id'))
  end
end
