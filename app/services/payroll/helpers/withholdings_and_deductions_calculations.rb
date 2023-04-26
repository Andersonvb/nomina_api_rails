module WithholdingsAndDeductionsCalculations
  def calculate_withholdings_and_deductions(payroll, total_social_security_and_parafiscal_base, total_social_security_ratio)
    base_salary = payroll.employee.salary

    deduction_health = base_salary * 0.04
    deduction_pension = base_salary * 0.04

    solidarity_fund = calculate_solidarity_fund(total_social_security_and_parafiscal_base, total_social_security_ratio)

    subsistence_account = calculate_subsistence_acount(total_social_security_and_parafiscal_base, total_social_security_ratio)

    total_withholdings_and_deductions = deduction_health + deduction_pension + solidarity_fund + subsistence_account

    {
      health: deduction_health,
      pension: deduction_pension,
      solidarity_fund: solidarity_fund,
      subsistence_account: subsistence_account,
      total: total_withholdings_and_deductions
    }
  end

  private

  def calculate_solidarity_fund(total_social_security_and_parafiscal_base, total_social_security_ratio)
    solidarity_fund_percentage = total_social_security_ratio >= 4 ? 0.01 : 0

    total_social_security_and_parafiscal_base * solidarity_fund_percentage
  end

  def calculate_subsistence_acount(total_social_security_and_parafiscal_base, total_social_security_ratio)
    subsistence_account_percentage = case total_social_security_ratio
    when 0...16 then 0
    when 16...17 then 0.002
    when 17...18 then 0.004
    when 18...19 then 0.006
    when 19...20 then 0.008
    else 0.01
    end

    subsistence_account_percentage * total_social_security_and_parafiscal_base
  end

end