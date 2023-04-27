module PayrollAsserts
  def payroll_asserts(payroll)
    refute payroll[:salary].nil?
    refute payroll[:salary_income].nil?
    refute payroll[:non_salary_income].nil?
    refute payroll[:deductions].nil?
    refute payroll[:transport_allowance].nil?

    refute payroll[:total_withholdings_and_deductions].nil?
    refute payroll[:deduction_health].nil?
    refute payroll[:deduction_pension].nil?
    refute payroll[:solidarity_fund].nil?
    refute payroll[:subsistence_account].nil?

    refute payroll[:total_social_security].nil?
    refute payroll[:social_security_health].nil?
    refute payroll[:social_security_pension].nil?
    refute payroll[:arl].nil?

    refute payroll[:total_parafiscal_contributions].nil?
    refute payroll[:compensation_fund].nil?
    refute payroll[:icbf].nil?
    refute payroll[:sena].nil?

    refute payroll[:total_social_benefits].nil?
    refute payroll[:severance_pay].nil?
    refute payroll[:interest_on_severance_pay].nil?
    refute payroll[:service_bonus].nil?
    refute payroll[:vacation].nil?

    refute payroll[:net_pay].nil?
    refute payroll[:company_total_cost].nil?

    assert_equal 750000.0, payroll[:salary]
    assert_equal 0.0, payroll[:salary_income]
    assert_equal 0.0, payroll[:non_salary_income]
    assert_equal 0.0, payroll[:deductions]
    assert_equal 117172.0, payroll[:transport_allowance]

    assert_equal 60000.0, payroll[:total_withholdings_and_deductions]
    assert_equal 30000.0, payroll[:deduction_health]
    assert_equal 30000.0, payroll[:deduction_pension]
    assert_equal 0.0, payroll[:solidarity_fund]
    assert_equal 0.0, payroll[:subsistence_account]

    assert_equal 142200.0, payroll[:total_social_security]
    assert_equal 0.0, payroll[:social_security_health]
    assert_equal 90000.0, payroll[:social_security_pension]
    assert_equal 52200.0, payroll[:arl]

    assert_equal 30000.0, payroll[:total_parafiscal_contributions]
    assert_equal 30000.0, payroll[:compensation_fund]
    assert_equal 0.0, payroll[:icbf]
    assert_equal 0.0, payroll[:sena]

    assert_equal 184450.0, payroll[:total_social_benefits]
    assert_equal 72264.0, payroll[:severance_pay]
    assert_equal 8672.0, payroll[:interest_on_severance_pay]
    assert_equal 72264.0, payroll[:service_bonus]
    assert_equal 31250.0, payroll[:vacation]

    assert_equal 807172.0, payroll[:net_pay]
    assert_equal 1223822.0, payroll[:company_total_cost]
  end
end