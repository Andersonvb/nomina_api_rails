class PayrollsController < ApplicationController
  before_action :set_payroll, only: [:show, :update, :destroy]

  def index
    @payrolls = Payroll.order(:id)
  end

  def show; end

  def create 
    @payroll = Payroll.new(payroll_params)

    if @payroll.save
      render :create, status: :ok
    else
      render @payroll.errors, status: :unprocessable_entity
    end
  end

  def update
    if @payroll.update(payroll_params)
      render :create, status: :ok
    else
      render @payroll.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @payroll.destroy
    head :no_content
  end

  private 

  def payroll_params
    params.require(:payroll).permit(:employee_id, :period_id, :salary_income, :non_salary_income, :deductions, :transport_allowance, :net_pay)
  end

  def set_payroll
    @payroll = Payroll.find(params[:id])
  end
end
