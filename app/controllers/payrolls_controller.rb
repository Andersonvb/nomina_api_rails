require_relative '../services/payroll/payroll_creator'

class PayrollsController < ApplicationController
  include RenderErrorJson

  before_action :set_payroll, only: [:show, :update, :destroy]
  before_action :set_user_companies
  before_action :validate_payroll_id, only: [:show, :update, :destroy]
  before_action :validate_period_id, only: [:create, :update]
  before_action :validate_employee_id, only: [:create, :update]

  def index
    periods = Period.joins(:company).where(companies: {id: @user_companies.pluck(:id)})

    @payrolls = Payroll.where(period_id: periods.pluck(:id))
  end

  def show; end

  def create 
    @payroll = Payroll.new(payroll_params)

    if PayrollCreator.call(@payroll)
      render :create, status: :created
    else
      render_error_json(@payroll, :unprocessable_entity)
    end
  end

  def update
    if @payroll.update(payroll_params) && PayrollCreator.call(@payroll)
      render :create, status: :ok
    else
      render_error_json(@payroll, :unprocessable_entity)
    end
  end

  def destroy
    @payroll.destroy
    head :no_content
  end

  private 

  def payroll_params
    params.require(:payroll).permit(:employee_id, :period_id, :salary_income, :non_salary_income, :deductions)
  end

  def set_payroll
    @payroll = Payroll.find(params[:id])
  end

  def set_user_companies
    @user_companies = Company.user_companies(@current_user.id)
  end

  def validate_payroll_id
    render_record_not_found unless user_company?(@payroll.period.company_id.to_i)
  end

  def validate_period_id
    puts "Validate period"
    render_invalid_model_id(:period_id) unless user_company?(Period.find(payroll_params[:period_id]).company_id.to_i)
  end

  def validate_employee_id
    render_invalid_model_id(:employee_id) unless user_company?(Employee.find(payroll_params[:employee_id]).company_id.to_i)
    
    render_no_salary_in_period_error unless Employee&.find(payroll_params[:employee_id])&.salary_on_date(Period.find(payroll_params[:period_id]).start_date)
  end

  def user_company?(company_id)
    @user_companies.pluck(:id).include?(company_id)
  end
end
