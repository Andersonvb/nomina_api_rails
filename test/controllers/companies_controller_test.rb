require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  include ParsedResponse
  include UserSupport

  def setup
    @company = companies(:company_one)

    @token = get_token
  end

  test 'valid index companies' do
    get_company_index 

    assert_response :success
  end

  private

  def get_token
    post "#{sessions_path}.json", params: { username: 'user_one', password: 'abc123' }
    JSON.parse(response.body)['token']
  end

  def get_company_index
    get "#{companies_path}.json", headers: { 'Authorization' => "#{@token}" }
  end
end
