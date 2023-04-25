require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  def setup
    @company = companies(:company_one)
  end

  test 'name column' do
    assert Company.column_names.include?('name') 

    assert_equal 'string', Company.column_for_attribute(:name).type.to_s, 'Correct name type'
  end

  test 'has_many :periods relation' do
    period = periods(:period_one)

    assert_equal @company, period.company, 'relation between period and company'
  end

  test 'has_many :employees relation' do
    employee = employees(:employee_one)

    assert_equal @company, employee.company, 'relation between employee and company'
  end

  test 'invalid without name' do
    @company.name = nil

    refute @company.valid?
    assert @company.errors[:name].present?, 'error without name'
  end

  test 'valid with name' do
    assert @company.valid?
  end

  test 'invalid name length' do
    @company.name = 'An'

    refute @company.valid?
    assert @company.errors[:name].present?, 'error with too short name'

    @company.name = 'a'*30
    refute @company.valid?
    assert @company.errors[:name].present?, 'error with too long name'
  end

  test 'invalid name with unsafe characters' do
    @company.name = 'An*#%:n'

    refute @company.valid?
    assert @company.errors[:name].present?, 'error name with unsafe characters'
  end
end
