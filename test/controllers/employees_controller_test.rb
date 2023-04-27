require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  include ParsedResponse
  include EmployeeAsserts
  include EmployeeSupport

  def setup
    @employee = employees(:employee_one)

    @token = get_token
  end

  test 'valid index employees' do
    get_employee_index 

    assert_response :ok
  end

  test 'valid show employees' do
    get_employee_show(@employee)

    assert_response :ok
    employee_response_asserts
  end

  test 'valid create employee' do
    params = employee_params

    post_employee_create(params)

    assert_response :created
    employee_response_asserts
  end

  test 'invalid create employee' do
    params = employee_params
    params[:employee][:name] = 'User@##$#%'

    post_employee_create(params)

    assert_response :unprocessable_entity
  end

  test 'valid update employee' do
    params = employee_params

    put_employee_update(@employee, params)

    assert_response :ok
    employee_response_asserts
  end

  test 'invalid update employee' do
    params = employee_params
    params[:employee][:name] = 'User#$@$'

    put_employee_update(@employee, params)

    assert_response :unprocessable_entity
  end

  test 'valid delete employee' do
    delete_employee_destroy(@employee)

    assert_response :no_content
  end
  
  private

  def get_token
    post "#{sessions_path}.json", params: { username: 'user_one', password: 'abc123' }
    JSON.parse(response.body)['token']
  end

  def get_employee_index
    get "#{employees_path}.json", headers: { 'Authorization' => "#{@token}" }
  end

  def get_employee_show(employee)
    get "#{employee_path(employee)}.json", headers: { 'Authorization' => "#{@token}" }
  end

  def post_employee_create(params)
    post "#{employees_path}.json", params: params, headers: { 'Authorization' => "#{@token}" }
  end

  def put_employee_update(employee, params)
    put "#{employee_path(employee)}.json", params: params, headers: { 'Authorization' => "#{@token}" }
  end

  def delete_employee_destroy(employee)
    delete "#{employee_path(employee)}.json", headers: { 'Authorization' => "#{@token}" }
  end
end
