json.id payroll.id
json.employee payroll.employee_id
json.period payroll.period_id
json.salary payroll.salary
json.salary_income payroll.salary_income
json.non_salary_income payroll.non_salary_income
json.transport_allowance payroll.transport_allowance

json.withholdings_and_deductions do
  json.health payroll.deduction_health
  json.pension payroll.deduction_pension
  json.solidarity_fund payroll.solidarity_fund
  json.subsistence_account payroll.subsistence_account
  json.total payroll.total_withholdings_and_deductions
end

json.social_security do
  json.health payroll.social_security_health
  json.pension payroll.social_security_pension
  json.arl payroll.arl
  json.total payroll.total_social_security
end

json.parafiscal_contributions do
  json.compensation_fund payroll.compensation_fund
  json.icbf payroll.icbf
  json.sena payroll.sena
  json.total payroll.total_parafiscal_contributions
end

json.social_benefits do
  json.severance_pay payroll.severance_pay
  json.interest_on_severance_pay payroll.interest_on_severance_pay
  json.service_bonus payroll.service_bonus
  json.vacation payroll.vacation
  json.total payroll.total_social_benefits
end

json.total_employee_payment payroll.net_pay
json.company_total_cost payroll.company_total_cost