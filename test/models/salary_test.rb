require "test_helper"

class SalaryTest < ActiveSupport::TestCase
  def setup
    @salary = salaries(:salary_one)
  end

  test 'value column' do
    assert Salary.column_names.include?('value') 

    assert_equal :decimal, Salary.column_for_attribute(:value).type, 'Correct value type'
  end

  test 'start_date column' do
    assert Salary.column_names.include?('start_date') 

    assert_equal :date, Salary.column_for_attribute(:start_date).type, 'Correct start_date type'
  end

  test 'end_date column' do
    assert Salary.column_names.include?('end_date') 

    assert_equal :date, Salary.column_for_attribute(:end_date).type, 'Correct end_date type'
  end

  test 'valid all attributes' do
    assert @salary.valid?
  end

  test 'invalid without value' do
    @salary.value = nil

    refute @salary.valid?
    assert @salary.errors[:value].present?, 'error without value'
  end

  test 'invalid without start_date' do
    @salary.start_date = nil

    refute @salary.valid?
    assert @salary.errors[:start_date].present?, 'error without start_date'
  end

  test 'invalid without end_date' do
    @salary.end_date = nil

    refute @salary.valid?
    assert @salary.errors[:end_date].present?, 'error without end_date'
  end

  test 'invalid with end_date before start_date' do
    @salary.end_date = '2023-01-01'
    @salary.start_date = '2023-01-31'

    refute @salary.valid?
    assert @salary.errors[:start_date].present?, 'error with end_date before start_date'
  end
end
