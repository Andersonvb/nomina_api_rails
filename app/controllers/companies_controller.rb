class CompaniesController < ApplicationController
  include RenderErrorJson

  before_action :set_company, only: [:show, :update, :destroy]

  def index
    @companies = Company.user_companies(@current_user.id)
  end

  def show
    if user_company?
      render :show, status: :ok
    else
      add_invalid_company_id_error

      render_error_json(@company, :unprocessable_entity)
    end
  end

  def create 
    @company = Company.new(company_params)

    valid_user_id = validate_user_id(company_params[:user_id])

    if valid_user_id && @company.save
      render :create, status: :created
    else
      add_invalid_user_id_error unless valid_user_id

      render_error_json(@company, :unprocessable_entity)
    end
  end

  def update
    valid_user_id = validate_user_id(company_params[:user_id])

    if validate_user_id(@company.user_id) && valid_user_id && @company.update(company_params)
      render @company, status: :ok
    else
      add_invalid_user_id_error unless valid_user_id

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

  def user_company?
    @current_user.companies.include?(@company)
  end

  def validate_user_id(user_id)
    @current_user.id == user_id
  end

  def add_invalid_company_id_error
    @company.errors.add(:base, I18n.t('activerecord.errors.models.company.base.not_valid_company_id'))
  end

  def add_invalid_user_id_error
    @company.errors.add(:user_id, I18n.t('activerecord.errors.models.company.user_id.not_valid_user_id'))
  end
end
