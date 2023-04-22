class EmployeesController < ApplicationController
  include RenderErrorJson

  before_action :set_employee, only: [:show, :update, :destroy]
  before_action :set_user_companies
  before_action :validate_company_id, only: [:create, :update]
  before_action :validate_employee_id, only: [:show, :update, :destroy]

  def index
    @employees = Employee.joins(:company).where(companies: {id: @user_companies.pluck(:id)})
  end

  def show; end

  def create 
    @employee = Employee.new(employee_params)

    if @employee.save
      render :create, status: :ok
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
    params.require(:employee).permit(:company_id, :name, :lastname, :salary, :start_date, :end_date)
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def set_user_companies
    @user_companies = Company.user_companies(@current_user.id)
  end

  def validate_company_id
    render_invalid_model_id(:company_id) unless user_company?(employee_params[:company_id])
  end

  def validate_employee_id
    render_record_not_found unless user_company?(@employee.company_id)
  end

  def user_company?(company_id)
    @user_companies.pluck(:id).include?(company_id)
  end
end
