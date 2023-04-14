class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy]

  def index
    @companies = Company.order(:id)
  end

  def show; end

  def create 
    @company = Company.new(company_params)

    if @company.save
      render :create, status: :ok
    else
      render :create.errors, status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      render @company, status: :ok
    else
      render @company.errors, status: :unprocessable_entity
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
end
