class PayrollsController < ApplicationController
  before_action :set_payroll, only: [:show, :update, :destroy]

  def index
    companies_ids = Company.where(user_id: @current_user.id).map { |company| company.id}
    periods_ids = Period.where(company_id: companies_ids).map { |period| period.id }

    @payrolls = Payroll.where(period_id: periods_ids)
  end

  def show
    if @payroll.period.company.user_id == @current_user.id
      render :show, status: :ok
    else
      @payroll.errors.add(:base, I18n.t('activerecord.errors.models.payroll.base.not_valid_payroll_id'))

      render 'errors/error', locals: { object: @payroll }, formats: :json, status: :unprocessable_entity
    end
  end

  def create 
    @payroll = Payroll.new(payroll_params)

    if @payroll.period.company.user_id == @current_user.id && @payroll.employee.company.user_id == @current_user.id && @payroll.save
      render :create, status: :ok
    else
      render 'errors/error', locals: { object: @payroll }, formats: :json, status: :unprocessable_entity
    end
  end

  def update
    if Period.find(payroll_params[:period_id]).company.user_id == @current_user.id && Employee.find(payroll_params[:employee_id]).company.user_id == @current_user.id && Payroll.find(params[:id]).period.company.user_id == @current_user.id && @payroll.update(payroll_params)
      render :create, status: :ok
    else
      render 'errors/error', locals: { object: @payroll }, formats: :json, status: :unprocessable_entity
    end
  end

  def destroy
    if Payroll.find(params[:id]).period.company.user_id == @current_user.id
      @payroll.destroy
      head :no_content
    else
      render json: { error: 'error' }
    end
  end

  private 

  def payroll_params
    params.require(:payroll).permit(:employee_id, :period_id, :salary_income, :non_salary_income, :deductions, :transport_allowance, :net_pay)
  end

  def set_payroll
    @payroll = Payroll.find(params[:id])
  end
end
