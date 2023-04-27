require "test_helper"

class PayrollsControllerTest < ActionDispatch::IntegrationTest
  include ParsedResponse
  include PayrollSupport
  include PayrollAsserts

  def setup
    @payroll = payrolls(:payroll_one)

    @token = get_token
  end

  test 'valid index payrolls' do
    get_payroll_index 

    assert_response :ok
  end

  test 'valid show payroll' do
    get_payroll_show(@payroll)

    assert_response :ok
    payroll_response_asserts
  end

  test 'valid create payroll' do
    params = payroll_new_params

    post_payroll_create(params)

    assert_response :created
    payroll_response_asserts
  end

  test 'valid update payroll' do
    params = payroll_params

    put_payroll_update(@payroll, params)

    assert_response :ok
    payroll_response_asserts
  end
  private

  def get_token
    post "#{sessions_path}.json", params: { username: 'user_one', password: 'abc123' }
    JSON.parse(response.body)['token']
  end

  def get_payroll_index
    get "#{payrolls_path}.json", headers: { 'Authorization' => "#{@token}" }
  end

  def get_payroll_show(payroll)
    get "#{payroll_path(payroll)}.json", headers: { 'Authorization' => "#{@token}" }
  end

  def post_payroll_create(params)
    post "#{sessions_path}.json", params: { username: 'user_two', password: 'abc123' }
    user_two_token = JSON.parse(response.body)['token']

    post "#{payrolls_path}.json", params: params, headers: { 'Authorization' => "#{user_two_token}" }
  end

  def put_payroll_update(payroll, params)
    put "#{payroll_path(payroll)}.json", params: params, headers: { 'Authorization' => "#{@token}" }
  end
end
