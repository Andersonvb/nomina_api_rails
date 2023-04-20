require_relative '../application_service'

class PayrollCreator < ApplicationService
  MINIMUM_SALARY = 1000000
  TRANSPORT_ALLOWANCE = 117172

  # MINIMUM_SALARY = 1160000
  # TRANSPORT_ALLOWANCE = 140606

  def initialize(payroll)
    @payroll = payroll
    @base_salary = @payroll.employee.salary
    @period_days = @payroll.period.duration_in_days
  end

  def call
    create_payroll
  end

  private 
  
  def create_payroll
    salary_ratio = calculate_salary_ratio

    salary = calculate_salary

    total_social_security_and_parafiscal_base = calcultate_total_social_security_and_parafiscal_base(salary)

    total_social_security_ratio = (total_social_security_and_parafiscal_base / MINIMUM_SALARY)

    transport_allowance = calculate_trasport_allowance(salary_ratio)

    social_benefits_total_base = calculate_social_benefits_total_base(total_social_security_and_parafiscal_base, transport_allowance)

    total_income = calculate_total_income(social_benefits_total_base)

    withholdings_and_deductions = calculate_withholdings_and_deductions(total_social_security_and_parafiscal_base, total_social_security_ratio)

    social_security = calculate_social_security(total_social_security_and_parafiscal_base, total_social_security_ratio)

    parafiscal_contributions = calculate_parafiscal_contributions(total_social_security_and_parafiscal_base, total_social_security_ratio)

    social_benefits = calculate_social_benefits(social_benefits_total_base, total_social_security_and_parafiscal_base)

    net_pay = calculate_net_pay(total_income, withholdings_and_deductions[:total])

    company_total_cost = calculate_company_total_cost(total_income, social_security[:total], parafiscal_contributions[:total], social_benefits[:total])

    set_payroll_attributes(salary, transport_allowance, withholdings_and_deductions, social_security, parafiscal_contributions, social_benefits, net_pay, company_total_cost)

    validate_and_save_payroll
  end

  def calculate_salary
    (@base_salary * @period_days) / 30
  end

  def calculate_salary_ratio
    @base_salary / MINIMUM_SALARY
  end

  def calculate_trasport_allowance(salary_ratio)
    salary_ratio <= 2 ? (TRANSPORT_ALLOWANCE * @period_days) / 30 : 0
  end

  def calcultate_total_social_security_and_parafiscal_base(salary)
    salary + @payroll.salary_income
  end

  def calculate_social_benefits_total_base(total_social_security_and_parafiscal_base, transport_allowance)
    total_social_security_and_parafiscal_base + transport_allowance
  end

  def calculate_total_income(social_benefits_total_base)
    social_benefits_total_base + @payroll.non_salary_income 
  end

  def calculate_withholdings_and_deductions(total_social_security_and_parafiscal_base, total_social_security_ratio)
    deduction_health = @base_salary * 0.04
    deduction_pension = @base_salary * 0.04

    solidarity_fund = calculate_solidarity_fund(total_social_security_and_parafiscal_base, total_social_security_ratio)

    subsistence_account = calculate_subsistence_acount(total_social_security_and_parafiscal_base, total_social_security_ratio)

    total_withholdings_and_deductions = deduction_health + deduction_pension + solidarity_fund + subsistence_account

    {
      health: deduction_health,
      pension: deduction_pension,
      subsistence_account: subsistence_account,
      total: total_withholdings_and_deductions
    }
  end

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

  def calculate_social_security(total_social_security_and_parafiscal_base, total_social_security_ratio)
    social_security_health_percentage = total_social_security_ratio < 10 ? 0 : 0.085
    social_security_health = total_social_security_and_parafiscal_base * social_security_health_percentage

    social_security_pension = total_social_security_and_parafiscal_base * 0.12

    arl = total_social_security_and_parafiscal_base * 0.0696

    total_social_security = social_security_health + social_security_pension + arl

    {
      health: social_security_health,
      pension: social_security_pension,
      arl: arl,
      total: total_social_security
    }
  end

  def calculate_parafiscal_contributions(total_social_security_and_parafiscal_base, total_social_security_ratio)
    compensation_fund = total_social_security_and_parafiscal_base * 0.04

    icbf_percentage = total_social_security_ratio < 10 ? 0 : 0.03
    icbf = total_social_security_and_parafiscal_base * icbf_percentage

    sena_percentage = total_social_security_ratio < 10 ? 0 : 0.02
    sena = total_social_security_and_parafiscal_base * sena_percentage

    total_parafiscal_contributions = compensation_fund + icbf + sena

    {
      compensation_fund: compensation_fund,
      icbf: icbf,
      sena: sena,
      total: total_parafiscal_contributions
    }
  end

  def calculate_social_benefits(social_benefits_total_base, total_social_security_and_parafiscal_base)
    severance_pay = social_benefits_total_base * 0.0833

    interest_on_severance_pay = (severance_pay * 0.12).round

    service_bonus = social_benefits_total_base * 0.0833

    vacation = total_social_security_and_parafiscal_base * 0.0417

    total_social_benefits = severance_pay + interest_on_severance_pay + service_bonus + vacation

    {
      severance_pay: severance_pay,
      interest_on_severance_pay: interest_on_severance_pay,
      service_bonus: service_bonus,
      vacation: vacation,
      total: total_social_benefits
    }
  end

  def calculate_net_pay(total_income, withholdings_and_deductions_total)
    total_income - withholdings_and_deductions_total
  end

  def calculate_company_total_cost(total_income, social_security_total, parafiscal_contributions_total, social_benefits_total)
    total_income + social_security_total + parafiscal_contributions_total + social_benefits_total 
  end

  def set_payroll_attributes(salary, transport_allowance, withholdings_and_deductions, social_security, parafiscal_contributions, social_benefits, net_pay, company_total_cost)
    @payroll.salary = salary
    @payroll.transport_allowance = transport_allowance

    @payroll.deduction_health = withholdings_and_deductions[:health]
    @payroll.deduction_pension = withholdings_and_deductions[:pension]
    @payroll.solidarity_fund = withholdings_and_deductions[:solidarity_fund]
    @payroll.subsistence_account = withholdings_and_deductions[:subsistence_account]
    @payroll.total_withholdings_and_deductions = withholdings_and_deductions[:total]

    @payroll.social_security_health = social_security[:health]
    @payroll.social_security_pension = social_security[:pension]
    @payroll.arl = social_security[:arl]
    @payroll.total_social_security = social_security[:total]

    @payroll.compensation_fund = parafiscal_contributions[:compensation_fund]
    @payroll.icbf = parafiscal_contributions[:icbf]
    @payroll.sena = parafiscal_contributions[:sena]
    @payroll.total_parafiscal_contributions = parafiscal_contributions[:total]

    @payroll.severance_pay = social_benefits[:severance_pay]
    @payroll.interest_on_severance_pay = social_benefits[:interest_on_severance_pay]
    @payroll.service_bonus = social_benefits[:service_bonus]
    @payroll.vacation = social_benefits[:vacation]
    @payroll.total_social_benefits = social_benefits[:total]

    @payroll.net_pay = net_pay
    @payroll.company_total_cost = company_total_cost
  end

  def validate_and_save_payroll
    if validate_company_id(@payroll.period.company_id) && validate_company_id(@payroll.employee.company_id) && @payroll.save
      true
    else
      false
    end
  end

  def validate_company_id(company_id)
    companies = Company.user_companies(@payroll.period.company.user_id)
    companies.pluck(:id).include?(company_id)
  end
end