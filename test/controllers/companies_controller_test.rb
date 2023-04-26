require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  include ParsedResponse
  include CompanyAsserts
  include CompanySupport

  def setup
    @company = companies(:company_one)

    @token = get_token
  end

  test 'valid index companies' do
    get_company_index 

    assert_response :ok
  end

  test 'valid show companies' do
    get_company_show(@company)

    assert_response :ok
    company_response_asserts
  end

  test 'valid create company' do
    params = company_params

    post_company_create(params)

    assert_response :created
    company_response_asserts
  end

  test 'invalid create company' do
    params = company_params
    params[:company][:name] = 'User#$@#$%'

    post_company_create(params)

    assert_response :unprocessable_entity
  end

  test 'valid update company' do
    params = company_params

    put_company_update(@company, params)

    assert_response :ok
    company_response_asserts
  end

  test 'invalid update company' do
    params = company_params
    params[:company][:name] = 'User#$@#$%'

    put_company_update(@company, params)

    assert_response :unprocessable_entity
  end

  test 'valid delete company' do
    delete_company_destroy(@company)

    assert_response :no_content
  end

  private

  def get_token
    post "#{sessions_path}.json", params: { username: 'user_one', password: 'abc123' }
    JSON.parse(response.body)['token']
  end

  def get_company_index
    get "#{companies_path}.json", headers: { 'Authorization' => "#{@token}" }
  end

  def get_company_show(company)
    get "#{company_path(company)}.json", headers: { 'Authorization' => "#{@token}" }
  end

  def post_company_create(params)
    post "#{companies_path}.json", params: params, headers: { 'Authorization' => "#{@token}" }
  end

  def put_company_update(company, params)
    put "#{company_path(company)}.json", params: params, headers: { 'Authorization' => "#{@token}" }
  end

  def delete_company_destroy(company)
    delete "#{company_path(company)}.json", headers: { 'Authorization' => "#{@token}" }
  end
end
