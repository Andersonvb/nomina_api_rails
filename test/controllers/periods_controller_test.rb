require "test_helper"

class PeriodsControllerTest < ActionDispatch::IntegrationTest
  include ParsedResponse
  include PeriodAsserts
  include PeriodSupport

  def setup
    @period = periods(:period_one)

    @token = get_token
  end

  test 'valid index periods' do
    get_period_index 

    assert_response :ok
  end

  test 'valid show period' do
    get_period_show(@period)

    assert_response :ok
    period_response_asserts
  end

  test 'valid create period' do
    params = period_params

    post_period_create(params)

    assert_response :created
    period_response_asserts
  end

  test 'invalid create period' do
    params = period_params
    params[:period][:start_date] = '2023-01-30'
    params[:period][:end_date] = '2023-01-01'

    post_period_create(params)

    assert_response :unprocessable_entity
  end

  test 'valid update period' do
    params = period_params

    put_period_update(@period, params)

    assert_response :ok
    period_response_asserts
  end

  test 'invalid update period' do
    params = period_params
    params[:period][:start_date] = '2023-01-30'
    params[:period][:end_date] = '2023-01-01'

    put_period_update(@period, params)

    assert_response :unprocessable_entity
  end

  test 'valid delete period' do
    delete_period_destroy(@period)

    assert_response :no_content
  end
  
  private

  def get_token
    post "#{sessions_path}.json", params: { username: 'user_one', password: 'abc123' }
    JSON.parse(response.body)['token']
  end

  def get_period_index
    get "#{periods_path}.json", headers: { 'Authorization' => "#{@token}" }
  end

  def get_period_show(period)
    get "#{period_path(period)}.json", headers: { 'Authorization' => "#{@token}" }
  end

  def post_period_create(params)
    post "#{periods_path}.json", params: params, headers: { 'Authorization' => "#{@token}" }
  end

  def put_period_update(period, params)
    put "#{period_path(period)}.json", params: params, headers: { 'Authorization' => "#{@token}" }
  end

  def delete_period_destroy(period)
    delete "#{period_path(period)}.json", headers: { 'Authorization' => "#{@token}" }
  end
end
