class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :update, :destroy]

  def index
    companies_id = Company.where(user_id: @current_user.id).map { |company| company.id }
    @employees = Employee.where(company_id: companies_id)
  end

  def show
    if @current_user.id == @employee.company.user_id
      render :show, status: :ok
    else
      @employee.errors.add(:base, I18n.t('activerecord.errors.models.employee.base.not_valid_employee_id'))

      render 'errors/error', locals: { object: @employee }, formats: :json, status: :unprocessable_entity
    end
  end

  def create 
    @employee = Employee.new(employee_params)
    companies = Company.where(user_id: @current_user.id)

    if companies.any? { |company| company.id == @employee.company_id } && @employee.save
      render :create, status: :ok
    else
      render 'errors/error', locals: { object: @employee }, formats: :json, status: :unprocessable_entity
    end
  end

  def update
    companies = Company.where(user_id: @current_user.id)

    if @employee.company.user_id == @current_user.id && companies.any? { |company| company.id == employee_params[:company_id] } && @employee.update(employee_params)
      render :create, status: :ok
    else
      render 'errors/error', locals: { object: @employee }, formats: :json, status: :unprocessable_entity
    end
  end

  def destroy
    companies = Company.where(user_id: @current_user.id)

    if companies.any? { |company| company.id == @employee.company_id }
      @employee.destroy
      head :no_content
    else
      render json: { error: 'error' }
    end
  end

  private 

  def employee_params
    params.require(:employee).permit(:company_id, :name, :lastname, :salary, :start_date, :end_date)
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end
end
