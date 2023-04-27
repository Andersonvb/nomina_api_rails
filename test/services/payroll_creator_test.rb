require "test_helper"
require_relative '../../app/services/payroll/payroll_creator'

class PayrollCreatorTest < ActiveSupport::TestCase
  include PayrollAsserts

  def setup
    @payroll = payrolls(:payroll_one)
  end

  test 'valid payroll creation' do
    payroll_created = PayrollCreator.call(@payroll)

    assert payroll_created
    payroll_asserts(@payroll)
  end

  test 'invalid payroll creation' do
    @payroll.period_id = nil

    payroll_created = PayrollCreator.call(@payroll)

    refute payroll_created
  end
end