class CompaniesController < ApplicationController
  include RenderErrorJson

  before_action :set_company, only: [:show, :update, :destroy]

  def index
    @companies = Company.user_companies(@current_user.id)
  end

  def show
    if user_company?(@company)
      render :show, status: :ok
    else
      add_invalid_company_id_error

      render_error_json(@company, :unprocessable_entity)
    end
  end

  def create 
    @company = Company.new(company_params)

    if validate_user_id(company_params[:user_id]) && @company.save
      render :create, status: :created
    else
      render_error_json(@company, :unprocessable_entity)
    end
  end

  def update
    if validate_user_id(@company.user_id) && validate_user_id(company_params[:user_id]) && @company.update(company_params)
      render @company, status: :ok
    else
      render_error_json(@company, :unprocessable_entity)
    end
  end

  def destroy
    if validate_user_id(@company.user_id)
      @company.destroy
      head :no_content
    else
      add_invalid_company_id_error

      render_error_json(@company, :unprocessable_entity)
    end
  end

  private 

  def company_params
    params.require(:company).permit(:user_id, :name)
  end

  def set_company
    @company = Company.find(params[:id])
  end

  def user_company?(company)
    @current_user.companies.include?(company)
  end

  def validate_user_id(user_id)
    @current_user.id == user_id
  end

  def add_invalid_company_id_error
    @company.errors.add(:base, I18n.t('activerecord.errors.models.company.base.not_valid_company_id'))
  end
end
