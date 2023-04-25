require "test_helper"

class PeriodTest < ActiveSupport::TestCase
  def setup
    @period = periods(:period_one)
  end

  test 'start_date column' do
    assert Period.column_names.include?('start_date') 

    assert_equal :date, Period.column_for_attribute(:start_date).type, 'Correct start_date type'
  end
  
  test 'end_date column' do
    assert Period.column_names.include?('end_date') 

    assert_equal :date, Period.column_for_attribute(:end_date).type, 'Correct end_date type'
  end

  test 'has_many :payrolls relation' do
    payroll = payrolls(:payroll_one)

    assert_equal @period, payroll.period, 'relation between period and payroll'
  end

  test 'valid all attributes' do
    assert @period.valid?
  end

  test 'invalid without start_date' do
    @period.start_date = nil

    refute @period.valid?
    assert @period.errors[:start_date].present?, 'error without start_date'
  end

  test 'invalid without end_date' do
    @period.end_date = nil

    refute @period.valid?
    assert @period.errors[:end_date].present?, 'error without end_date'
  end

  test 'invalid with end_date before start_date' do
    @period.end_date = '2023-01-01'
    @period.start_date = '2023-01-31'

    refute @period.valid?
    assert @period.errors[:start_date].present?, 'error with end_date before start_date'
  end
end
