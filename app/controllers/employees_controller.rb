class EmployeesController < ApplicationController
  include RenderErrorJson

  before_action :set_employee, only: [:show, :update, :destroy]
  before_action :validate_company_owner, only: [:create, :update]
  before_action :validate_employee_owner, only: [:show, :update, :destroy]

  def index
    user_companies = Company.user_companies(@current_user.id)

    @employees = Employee.joins(:company).where(companies: {id: user_companies.pluck(:id)})
  end

  def show; end

  def create 
    @employee = Employee.new(employee_params)

    if @employee.save
      render :create, status: :created
    else
      render_error_json(@employee, :unprocessable_entity)
    end
  end

  def update
    if @employee.update(employee_params)
      render :create, status: :ok
    else
      render_error_json(@employee, :unprocessable_entity)
    end
  end

  def destroy
      @employee.destroy
      head :no_content
  end

  private 

  def employee_params
    params.require(:employee).permit(:company_id, :name, :lastname, :start_date, :end_date)
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def validate_company_owner
    company = Company.find(employee_params[:company_id])

    render_invalid_id_error(:company_id) unless belongs_to_current_user?(company)
  end

  def validate_employee_owner
    render_record_not_found unless belongs_to_current_user?(@employee.company)
  end

  def belongs_to_current_user?(company)
    company.user == @current_user
  end
end
