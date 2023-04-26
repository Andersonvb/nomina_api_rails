require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ParsedResponse
  include UserAsserts
  include UserSupport

  def setup
    @user = users(:user_one)
  end 

  test 'valid index users' do
    get_user_index 

    assert_response :success
    
    all_users_size = User.all.size
    response_users_size = response_data.size
    assert_equal all_users_size, response_users_size, 'All records count in Index'
  end

  test 'valid show user' do
    get_user_show(@user)

    assert_response :ok
    user_response_asserts
  end

  test 'valid create user' do
    params = user_params

    post_user_create(params)

    assert_response :ok
    user_response_asserts
  end

  test 'invalid create user' do
    params = user_params
    params[:user][:name] = 'User#$@#$%'

    post_user_create(params)

    assert_response :unprocessable_entity
  end

  test 'valid update user' do
    params = user_params

    put_user_update(@user, params)

    assert_response :ok
    user_response_asserts
  end

  test 'invalid update user' do
    params = user_params
    params[:user][:name] = 'User#$@#$%'

    put_user_update(@user, params)

    assert_response :unprocessable_entity
  end

  test 'valid delete user' do
    delete_user_destroy(@user)

    assert_response :no_content
  end


  private

  def get_user_index
    get "#{users_path}.json"
  end

  def get_user_show(user)
    get "#{user_path(user)}.json"
  end

  def post_user_create(params)
    post "#{users_path}.json", params: params
  end
  
  def put_user_update(user, params)
    put "#{user_path(user)}.json", params: params
  end

  def delete_user_destroy(user)
    delete "#{user_path(user)}"
  end
end
