require "test_helper"

class SalariesControllerTest < ActionDispatch::IntegrationTest
  include ParsedResponse
  include SalaryAsserts
  include SalarySupport

  def setup
    @salary = salaries(:salary_one)

    @token = get_token
  end

  test 'valid index salaries' do
    get_salary_index 

    assert_response :ok
  end

  test 'valid show salary' do
    get_salary_show(@salary)

    assert_response :ok
    salary_response_asserts
  end

  test 'valid create salary' do
    params = salary_params

    post_salary_create(params)

    assert_response :created
    salary_response_asserts
  end

  test 'invalid create salary' do
    params = salary_params
    params[:salary][:start_date] = '2023-01-30'
    params[:salary][:end_date] = '2023-01-01'

    post_salary_create(params)

    assert_response :unprocessable_entity
  end

  test 'valid update salary' do
    params = salary_params

    put_salary_update(@salary, params)
    
    assert_response :ok
    salary_response_asserts
  end

  test 'invalid update salary' do
    params = salary_params
    params[:salary][:start_date] = '2023-01-30'
    params[:salary][:end_date] = '2023-01-01'

    put_salary_update(@salary, params)

    assert_response :unprocessable_entity
  end

  test 'valid delete salary' do
    delete_salary_destroy(@salary)

    assert_response :no_content
  end

  private

  def get_token
    post "#{sessions_path}.json", params: { username: 'user_one', password: 'abc123' }
    JSON.parse(response.body)['token']
  end

  def get_salary_index
    get "#{salaries_path}.json", headers: { 'Authorization' => "#{@token}" }
  end

  def get_salary_show(salary)
    get "#{salary_path(salary)}.json", headers: { 'Authorization' => "#{@token}" }
  end

  def post_salary_create(params)
    post "#{salaries_path}.json", params: params, headers: { 'Authorization' => "#{@token}" }
  end

  def put_salary_update(salary, params)
    put "#{salary_path(salary)}.json", params: params, headers: { 'Authorization' => "#{@token}" }
  end

  def delete_salary_destroy(salary)
    delete "#{salary_path(salary)}.json", headers: { 'Authorization' => "#{@token}" }
  end
end
