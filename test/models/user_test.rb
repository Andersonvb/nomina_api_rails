require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
  end  

  test 'name column' do
    assert User.column_names.include?('name') 

    assert_equal 'string', User.column_for_attribute(:name).type.to_s, 'Correct name type'
  end

  test 'lastname column' do
    assert User.column_names.include?('lastname') 

    assert_equal 'string', User.column_for_attribute(:lastname).type.to_s, 'Correct lastname type'
  end
  
  test 'username column' do
    assert User.column_names.include?('username') 

    assert_equal 'string', User.column_for_attribute(:username).type.to_s, 'Correct username type'
  end

  test 'password_digest column' do
    assert User.column_names.include?('password_digest') 

    assert_equal 'string', User.column_for_attribute(:password_digest).type.to_s, 'Correct password_digest type'
  end

  test 'has_many :companies relation' do
    company = companies(:company_one)

    assert_equal @user, company.user, 'relation between user and company'
  end

  test 'valid with all attributes' do
    assert @user.valid?
  end

  test 'invalid without name' do
    @user.name = nil

    refute @user.valid?
    assert @user.errors[:name].present?, 'error without name'
  end

  test 'invalid without lastname' do
    @user.lastname = nil

    refute @user.valid?
    assert @user.errors[:lastname].present?, 'error without lastname'
  end

  test 'invalid without username' do
    @user.username = nil

    refute @user.valid?
    assert @user.errors[:username].present?, 'error without username'
  end

  test 'invalid without password' do
    @user.password = nil

    refute @user.valid?
    assert @user.errors[:password].present?, 'error without password'
  end

  test 'invalid name length' do
    @user.name = 'Ab'

    refute @user.valid?
    assert @user.errors[:name].present?, 'error with too short name'

    @user.name = 'a'*30

    refute @user.valid?
    assert @user.errors[:name].present?, 'error with too long name'
  end

  test 'invalid lastname length' do
    @user.lastname = 'Ab'

    refute @user.valid?
    assert @user.errors[:lastname].present?, 'error with too short lastname'

    @user.lastname = 'a'*30

    refute @user.valid?
    assert @user.errors[:lastname].present?, 'error with too long lastname'
  end

  test 'invalid username length' do
    @user.username = 'Ab'

    refute @user.valid?
    assert @user.errors[:username].present?, 'error with too short username'

    @user.username = 'a'*30

    refute @user.valid?
    assert @user.errors[:username].present?, 'error with too long username'
  end

  test 'invalid name with unsafe characters' do
    @user.name = 'An*#%:n'

    refute @user.valid?
    assert @user.errors[:name].present?, 'error name with unsafe characters'
  end

  test 'invalid lastname with unsafe characters' do
    @user.lastname = 'An*#%:n'

    refute @user.valid?
    assert @user.errors[:lastname].present?, 'error lastname with unsafe characters'
  end

  test 'invalid username with unsafe characters' do
    @user.username = 'An*#%:n'

    refute @user.valid?
    assert @user.errors[:username].present?, 'error username with unsafe characters'
  end

end
