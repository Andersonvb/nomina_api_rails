require_relative '../application_service'
require_relative './helpers/social_benefits_calculations'
require_relative './helpers/parafiscal_contributions_calculations'
require_relative './helpers/social_security_calculations'
require_relative './helpers/withholdings_and_deductions_calculations'
require_relative './helpers/income_calculations'
require_relative './helpers/total_calculations'

class PayrollCreator < ApplicationService
  include IncomeCalculations
  include WithholdingsAndDeductionsCalculations
  include SocialSecurityCalculations
  include ParafiscalContributionsCalculations
  include SocialBenefitsCalculations
  include TotalCalculations

  def initialize(payroll)
    @payroll = payroll
  end

  def call
    return false unless valid_payroll?

    create_payroll
  end

  private 
  
  def create_payroll
    incomes = calculate_incomes(@payroll)

    withholdings_and_deductions = calculate_withholdings_and_deductions(@payroll, incomes[:total_social_security_and_parafiscal_base], incomes[:total_social_security_ratio])

    social_security = calculate_social_security(incomes[:total_social_security_and_parafiscal_base], incomes[:total_social_security_ratio])

    parafiscal_contributions = calculate_parafiscal_contributions(incomes[:total_social_security_and_parafiscal_base], incomes[:total_social_security_ratio])

    social_benefits = calculate_social_benefits(incomes[:social_benefits_total_base], incomes[:total_social_security_and_parafiscal_base])

    totals = calculate_total(incomes, withholdings_and_deductions, social_security, social_benefits, parafiscal_contributions)

    set_payroll_attributes(incomes, withholdings_and_deductions, social_security, parafiscal_contributions, social_benefits, totals)

    validate_and_save_payroll
  end

  def set_payroll_attributes(incomes, withholdings_and_deductions, social_security, parafiscal_contributions, social_benefits, totals)
    @payroll.salary = incomes[:salary]
    @payroll.transport_allowance = incomes[:transport_allowance]

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

    @payroll.net_pay = totals[:employee_net_pay]
    @payroll.company_total_cost = totals[:company_total_cost]
  end

  def validate_and_save_payroll
    return false unless @payroll.valid?
    
    @payroll.save
  end

  def valid_payroll?
    return false if @payroll.period_id.nil? 
    return false if @payroll.employee_id.nil? 
    return false if @payroll.salary_income.nil? 
    return false if @payroll.non_salary_income.nil? 
    return false if @payroll.deductions.nil? 
    true
  end
end