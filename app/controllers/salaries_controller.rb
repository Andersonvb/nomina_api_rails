class SalariesController < ApplicationController
  include RenderErrorJson

  before_action :set_salary, only: [:show, :update, :destroy]
  before_action :set_user_companies
  before_action :validate_salary_id, only: [:show, :update, :destroy]
  before_action :validate_employee_id, only: [:create, :update]

  def index
    employees = Employee.joins(:company).where(companies: {id: @user_companies.pluck(:id)})

    @payrolls = Payroll.where(employee_id: employees.pluck(:id))
  end

  def show; end

  def create
    @salary = Salary.new(salary_params)

    if @salary.save
      render :create, status: :created
    else
      render_error_json(@salary, :unprocessable_entity)
    end
  end

  def update
    if @salary.update(salary_params)
      render :create, status: :ok
    else
      render_error_json(@salary, :unprocessable_entity)
    end
  end

  def destroy
    @salary.destroy
    head :no_content
  end

  private

  def salary_params
    params.require(:salary).permit(:employee_id, :value, :start_date, :end_date)
  end

  def set_salary
    @salary = Salary.find(params[:id])
  end

  def set_user_companies
    @user_companies = Company.user_companies(@current_user.id)
  end

  def validate_salary_id
    render_record_not_found unless user_company?(@salary.employee.company_id)
  end

  def validate_employee_id
    render_invalid_model_id(:employee_id) unless user_company?(Employee.find(salary_params[:employee_id]).company_id)
  end

  def user_company?(company_id)
    @user_companies.pluck(:id).include?(company_id)
  end
end
