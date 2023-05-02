require_relative '../services/payroll/payroll_creator'

class PayrollsController < ApplicationController
  include RenderErrorJson

  before_action :set_payroll, only: [:show, :update, :destroy]
  before_action :set_employee, only: [:create, :update]
  before_action :set_period, only: [:create, :update]
  before_action :validate_payroll_owner, only: [:show, :update, :destroy]
  before_action :validate_period_owner, only: [:create, :update]
  before_action :validate_employee_owner, only: [:create, :update]
  before_action :validate_salary_for_period, only: [:create, :update]

  def index
    user_companies = Company.user_companies(@current_user.id)

    user_periods = Period.joins(:company).where(companies: {id: user_companies.pluck(:id)})

    @payrolls = Payroll.where(period_id: user_periods.pluck(:id))
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

  def set_employee
    @employee = Employee.find(payroll_params[:employee_id])
  end

  def set_period
    @period = Period.find(payroll_params[:period_id])
  end

  def validate_period_owner
    render_invalid_id_error(:period_id) unless belongs_to_current_user?(@period)
  end

  def validate_employee_owner
    render_invalid_id_error(:employee_id) unless belongs_to_current_user?(@employee)    
  end

  def validate_payroll_owner
    payroll_period = @payroll.period
    
    render_record_not_found unless belongs_to_current_user?(payroll_period)
  end

  def belongs_to_current_user?(object)
    object.company.user == @current_user
  end

  def validate_salary_for_period
    render_no_salary_for_period_error unless @employee&.salary_on_date(@period.start_date)
  end
end
