module PayrollAsserts
  def payroll_response_asserts
    payroll = Payroll.find(response_data['id'])

    assert_equal payroll.id, response_data['id']
    assert_equal payroll.salary_income, response_data['salary_income'].to_f
    assert_equal payroll.non_salary_income, response_data['non_salary_income'].to_f
    assert_equal payroll.deductions, response_data['deductions'].to_f
  end
end