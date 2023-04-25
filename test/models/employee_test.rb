require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  def setup
    @employee = employees(:employee_one)
  end

  test 'name column' do
    assert Employee.column_names.include?('name') 

    assert_equal 'string', Employee.column_for_attribute(:name).type.to_s, 'Correct name type'
  end

  test 'lastname column' do
    assert Employee.column_names.include?('lastname') 

    assert_equal 'string', Employee.column_for_attribute(:lastname).type.to_s, 'Correct lastname type'
  end

  test 'salary column' do
    assert Employee.column_names.include?('salary') 

    assert_equal :decimal, Employee.column_for_attribute(:salary).type, 'Correct salary type'
  end

  test 'start_date column' do
    assert Employee.column_names.include?('start_date') 

    assert_equal :date, Employee.column_for_attribute(:start_date).type, 'Correct start date type'
  end

  test 'end_date column' do
    assert Employee.column_names.include?('end_date') 

    assert_equal :date, Employee.column_for_attribute(:end_date).type, 'Correct end date type'
  end

  test 'has_many :payrolls relation' do
    payroll = payrolls(:payroll_one)

    assert_equal @employee, payroll.employee, 'relation between employee and payroll'
  end

  test 'valid all attributes' do
    assert @employee.valid?
  end

  test 'invalid without name' do
    @employee.name = nil

    refute @employee.valid?
    assert @employee.errors[:name].present?, 'error without name'
  end

  test 'invalid without lastname' do
    @employee.lastname = nil

    refute @employee.valid?
    assert @employee.errors[:lastname].present?, 'error without lastname'
  end

  test 'invalid without salary' do
    @employee.salary = nil

    refute @employee.valid?
    assert @employee.errors[:salary].present?, 'error without salary'
  end

  test 'invalid without start_date' do
    @employee.start_date = nil

    refute @employee.valid?
    assert @employee.errors[:start_date].present?, 'error without start_date'
  end

  test 'invalid without end_date' do
    @employee.end_date = nil

    refute @employee.valid?
    assert @employee.errors[:end_date].present?, 'error without end_date'
  end

  test 'invalid name length' do
    @employee.name = 'An'

    refute @employee.valid?
    assert @employee.errors[:name].present?, 'error with too short name'

    @employee.name = 'a'*30

    refute @employee.valid?
    assert @employee.errors[:name].present?, 'error with too long name'
  end

  test 'invalid lastname length' do
    @employee.lastname = 'An'

    refute @employee.valid?
    assert @employee.errors[:lastname].present?, 'error with too short lastname'

    @employee.lastname = 'a'*30

    refute @employee.valid?
    assert @employee.errors[:lastname].present?, 'error with too long lastname'
  end

  test 'invalid name with unsafe character' do
    @employee.name = "A#$@n"
    
    refute @employee.valid?
    assert @employee.errors[:name].present?, 'error with too long name'
  end

  test 'invalid lastname with unsafe character' do
    @employee.lastname = "A#$@n"
    
    refute @employee.valid?
    assert @employee.errors[:lastname].present?, 'error with too long lastname'
  end

  test 'invalid with end_date before start_date' do
    @employee.end_date = '2023-01-01'
    @employee.start_date = '2023-01-31'

    refute @employee.valid?
    assert @employee.errors[:start_date].present?, 'error with end_date before start_date'
  end
end
