class SalariesController < ApplicationController
  include RenderErrorJson

  before_action :set_salary, only: [:show, :update, :destroy]
  before_action :validate_salary_owner, only: [:show, :update, :destroy]
  before_action :validate_employee_owner, only: [:create, :update]

  def index
    user_companies = Company.user_companies(@current_user.id)

    employees = Employee.joins(:company).where(companies: {id: user_companies.pluck(:id)})

    @salaries = Salary.where(employee_id: employees.pluck(:id))
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

  def validate_salary_owner
    render_record_not_found unless belongs_to_current_user?(@salary.employee)
  end

  def validate_employee_owner
    employee = Employee.find(salary_params[:employee_id])

    render_invalid_id_error(:employee_id) unless belongs_to_current_user?(employee)
  end

  def belongs_to_current_user?(employee)
    employee.company.user == @current_user
  end
end
