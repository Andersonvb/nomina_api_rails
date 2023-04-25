require "test_helper"

class PayrollTest < ActiveSupport::TestCase
  def setup
    @payroll = payrolls(:payroll_one)
  end

  test 'salary column' do
    assert Payroll.column_names.include?('salary') 

    assert_equal :float, Payroll.column_for_attribute(:salary).type, 'correct salary type'
  end

  test 'salary_income column' do
    assert Payroll.column_names.include?('salary_income') 

    assert_equal :decimal, Payroll.column_for_attribute(:salary_income).type, 'correct salary_income type'
  end

  test 'non_salary_income column' do
    assert Payroll.column_names.include?('non_salary_income') 

    assert_equal :decimal, Payroll.column_for_attribute(:non_salary_income).type, 'correct salary_income type'
  end

  test 'deductions column' do
    assert Payroll.column_names.include?('deductions') 

    assert_equal :decimal, Payroll.column_for_attribute(:deductions).type, 'correct deductions type'
  end

  test 'transport_allowance column' do
    assert Payroll.column_names.include?('transport_allowance')

    assert_equal :decimal, Payroll.column_for_attribute(:transport_allowance).type, 'correct transport_allowance type'
  end
  
  test 'total_withholdings_and_deductions column' do
    assert Payroll.column_names.include?('total_withholdings_and_deductions')
    
    assert_equal :float, Payroll.column_for_attribute(:total_withholdings_and_deductions).type, 'correct total_withholdings_and_deductions type'
  end
  
  test 'deduction_health column' do
    assert Payroll.column_names.include?('deduction_health')

    assert_equal :float, Payroll.column_for_attribute(:deduction_health).type, 'correct deduction_health type'
  end
  
  test 'deduction_pension column' do
    assert Payroll.column_names.include?('deduction_pension')

    assert_equal :float, Payroll.column_for_attribute(:deduction_pension).type, 'correct deduction_pension type'
  end
  
  test 'solidarity_fund column' do
    assert Payroll.column_names.include?('solidarity_fund')

    assert_equal :float, Payroll.column_for_attribute(:solidarity_fund).type, 'correct solidarity_fund type'
  end
  
  test 'subsistence_account column' do
    assert Payroll.column_names.include?('subsistence_account')

    assert_equal :float, Payroll.column_for_attribute(:subsistence_account).type, 'correct subsistence_account type'
  end
  
  test 'total_social_security column' do
    assert Payroll.column_names.include?('total_social_security')

    assert_equal :float, Payroll.column_for_attribute(:total_social_security).type, 'correct total_social_security type'
  end
  
  test 'social_security_health column' do
    assert Payroll.column_names.include?('social_security_health')

    assert_equal :float, Payroll.column_for_attribute(:social_security_health).type, 'correct social_security_health type'
  end
  
  test 'social_security_pension column' do
    assert Payroll.column_names.include?('social_security_pension')

    assert_equal :float, Payroll.column_for_attribute(:social_security_pension).type, 'correct social_security_pension type'
  end
  
  test 'arl column' do
    assert Payroll.column_names.include?('arl')

    assert_equal :float, Payroll.column_for_attribute(:arl).type, 'correct arl type'
  end
  
  test 'total_parafiscal_contributions column' do
    assert Payroll.column_names.include?('total_parafiscal_contributions')
    
    assert_equal :float, Payroll.column_for_attribute(:total_parafiscal_contributions).type, 'correct total_parafiscal_contributions type'
  end
  
  test 'compensation_fund column' do
    assert Payroll.column_names.include?('compensation_fund')

    assert_equal :float, Payroll.column_for_attribute(:compensation_fund).type, 'correct compensation_fund type'
  end
  
  test 'icbf column' do
    assert Payroll.column_names.include?('icbf')

    assert_equal :float, Payroll.column_for_attribute(:icbf).type, 'correct icbf type'
  end
  
  test 'sena column' do
    assert Payroll.column_names.include?('sena')

    assert_equal :float, Payroll.column_for_attribute(:sena).type, 'correct sena type'
  end
  
  test 'total_social_benefits column' do
    assert Payroll.column_names.include?('total_social_benefits')

    assert_equal :float, Payroll.column_for_attribute(:total_social_benefits).type, 'correct total_social_benefits type'
  end

  test 'severance_pay column' do
    assert Payroll.column_names.include?('severance_pay')

    assert_equal :float, Payroll.column_for_attribute(:severance_pay).type, 'correct severance_pay type'
  end
  
  test 'interest_on_severance_pay column' do
    assert Payroll.column_names.include?('interest_on_severance_pay')

    assert_equal :float, Payroll.column_for_attribute(:interest_on_severance_pay).type, 'correct interest_on_severance_pay type'
  end
  
  test 'service_bonus column' do
    assert Payroll.column_names.include?('service_bonus')

    assert_equal :float, Payroll.column_for_attribute(:service_bonus).type, 'correct service_bonus type'
  end
  
  test 'vacation column' do
    assert Payroll.column_names.include?('vacation')

    assert_equal :float, Payroll.column_for_attribute(:vacation).type, 'correct vacation type'
  end
  
  test 'net_pay column' do
    assert Payroll.column_names.include?('net_pay')

    assert_equal :decimal, Payroll.column_for_attribute(:net_pay).type, 'correct net_pay type'
  end
  
  test 'company_total_cost column' do
    assert Payroll.column_names.include?('company_total_cost')

    assert_equal :float, Payroll.column_for_attribute(:company_total_cost).type, 'correct company_total_cost type'
  end

  test 'invalid without salary_income' do
    @payroll.salary_income = nil

    refute @payroll.valid?
    assert @payroll.errors[:salary_income].present?, 'error without salary_income'
  end

  test 'invalid without non_salary_income' do
    @payroll.non_salary_income = nil

    refute @payroll.valid?
    assert @payroll.errors[:non_salary_income].present?, 'error without non_salary_income'
  end

  test 'invalid without deductions' do
    @payroll.deductions = nil

    refute @payroll.valid?
    assert @payroll.errors[:deductions].present?, 'error without deductions'
  end
end
