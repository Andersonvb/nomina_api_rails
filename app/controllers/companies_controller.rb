class CompaniesController < ApplicationController
  include RenderErrorJson

  before_action :set_company, only: [:show, :update, :destroy]
  before_action :validate_user_id, only: [:create, :update]
  before_action :validate_company_id, only: [:show, :update, :destroy]

  def index
    @companies = @current_user.companies
  end

  def show; end

  def create 
    @company = @current_user.companies.new(company_params)

    if @company.save
      render :create, status: :created
    else
      render_error_json(@company, :unprocessable_entity)
    end
  end

  def update
    if @company.update(company_params)
      render :create, status: :ok
    else
      render_error_json(@company, :unprocessable_entity)
    end
  end

  def destroy
    @company.destroy
    head :no_content
  end

  private 

  def company_params
    params.require(:company).permit(:user_id, :name)
  end

  def set_company
    @company = Company.find(params[:id])
  end

  def validate_user_id
    render_invalid_model_id(:user_id) unless @current_user.id == company_params[:user_id].to_i 
  end

  def validate_company_id
    render_record_not_found unless user_company?
  end

  def user_company?
    @current_user.companies.include?(@company)
  end
end
