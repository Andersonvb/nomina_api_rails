module TotalCalculations
  def calculate_total(incomes, withholdings_and_deductions, social_security, social_benefits, parafiscal_contributions)
    net_pay = calculate_net_pay(incomes[:total], withholdings_and_deductions[:total])

    company_total_cost = calculate_company_total_cost(incomes[:total], social_security[:total], parafiscal_contributions[:total], social_benefits[:total])

    {
      employee_net_pay: net_pay,
      company_total_cost: company_total_cost
    }
  end

  def calculate_net_pay(total_income, withholdings_and_deductions_total)
    total_income - withholdings_and_deductions_total
  end

  def calculate_company_total_cost(total_income, social_security_total, parafiscal_contributions_total, social_benefits_total)
    total_income + social_security_total + parafiscal_contributions_total + social_benefits_total 
  end
end
