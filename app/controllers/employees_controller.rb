class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :update, :destroy]

  def index
    @employees = Employee.order(:id)
  end

  def show; end

  def create 
    @employee = Employee.new(employee_params)

    if @employee.save
      render :create, status: :ok
    else
      render @employee.errors, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update(employee_params)
      render :create, status: :ok
    else
      render @employee.errors, status: :unprocessable_entity
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
end
