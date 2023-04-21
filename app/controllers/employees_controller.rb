class EmployeesController < ApplicationController
  include RenderErrorJson

  before_action :set_employee, only: [:show, :update, :destroy]
  before_action :set_companies

  def index
    @employees = Employee.joins(:company).where(companies: {id: @companies.pluck(:id)})
  end

  def show
    if validate_user_id(@employee.company.user_id)
      render :show, status: :ok
    else
      add_invalid_employee_id_error

      render_error_json(@employee, :unprocessable_entity)
    end
  end

  def create 
    @employee = Employee.new(employee_params)

    valid_company_id = validate_company_id(@employee.company_id)

    if valid_company_id && @employee.save
      render :create, status: :ok
    else
      add_invalid_company_id_error unless valid_company_id

      render_error_json(@employee, :unprocessable_entity)
    end
  end

  def update
    valid_company_id_from_body = validate_company_id(employee_params[:company_id])
    valid_company_id_from_params = validate_company_id(@employee.company_id)

    if valid_company_id_from_params && valid_company_id_from_body && @employee.update(employee_params)
      render :create, status: :ok
    else
      add_invalid_company_id_error if !valid_company_id_from_body || !valid_company_id_from_params

      render_error_json(@employee, :unprocessable_entity)
    end
  end

  def destroy
    if validate_company_id(@employee.company_id)
      @employee.destroy
      head :no_content
    else
      add_invalid_employee_id_error

      render_error_json(@employee, :unprocessable_entity)
    end
  end

  private 

  def employee_params
    params.require(:employee).permit(:company_id, :name, :lastname, :salary, :start_date, :end_date)
  end

  def set_employee
    @employee = Employee.find(params[:id])
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

  def add_invalid_employee_id_error
    @employee.errors.add(:base, I18n.t('activerecord.errors.models.employee.base.not_valid_employee_id'))
  end

  def add_invalid_company_id_error
    @employee.errors.add(:company_id, I18n.t('activerecord.errors.models.employee.company.not_valid_company_id'))
  end
end
