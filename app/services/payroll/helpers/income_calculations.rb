module IncomeCalculations
  def calculate_incomes(payroll, minimum_salary, transport_allowance)
    base_salary = payroll.employee.salary

    period_days = payroll.period.duration_in_days

    salary_ratio = calculate_salary_ratio(base_salary, minimum_salary)

    salary = calculate_salary(base_salary, period_days)

    total_social_security_and_parafiscal_base = calculate_total_social_security_and_parafiscal_base(salary, payroll)

    total_social_security_ratio = calculate_total_social_security_ratio(total_social_security_and_parafiscal_base, minimum_salary)

    transport_allowance = calculate_transport_allowance(salary_ratio, period_days, transport_allowance)

    social_benefits_total_base = calculate_social_benefits_total_base(total_social_security_and_parafiscal_base, transport_allowance)

    total_income = calculate_total_income(social_benefits_total_base, payroll)

    {
      salary: salary,
      salary_ratio: salary_ratio,
      total_social_security_and_parafiscal_base: total_social_security_and_parafiscal_base,
      total_social_security_ratio: total_social_security_ratio,
      transport_allowance: transport_allowance, 
      social_benefits_total_base: social_benefits_total_base,
      total: total_income
    }
  end

  private

  def calculate_salary(base_salary, period_days)
    (base_salary * period_days) / 30
  end

  def calculate_salary_ratio(base_salary, minimum_salary)
    base_salary / minimum_salary
  end

  def calculate_transport_allowance(salary_ratio, period_days, transport_allowance)
    salary_ratio <= 2 ? (transport_allowance * period_days) / 30 : 0
  end

  def calculate_total_social_security_and_parafiscal_base(salary, payroll)
    salary + payroll.salary_income
  end

  def calculate_total_social_security_ratio(total_social_security_and_parafiscal_base, minimum_salary)
    (total_social_security_and_parafiscal_base / minimum_salary)
  end

  def calculate_social_benefits_total_base(total_social_security_and_parafiscal_base, transport_allowance)
    total_social_security_and_parafiscal_base + transport_allowance
  end

  def calculate_total_income(social_benefits_total_base, payroll)
    social_benefits_total_base + payroll.non_salary_income 
  end
end