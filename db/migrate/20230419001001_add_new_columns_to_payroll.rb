class AddNewColumnsToPayroll < ActiveRecord::Migration[7.0]
  def change
    add_column :payrolls, :deduction_health, :float
    add_column :payrolls, :deduction_pension, :float
    add_column :payrolls, :solidarity_fund, :float
    add_column :payrolls, :subsistence_account, :float
    add_column :payrolls, :social_security_health, :float
    add_column :payrolls, :social_security_pension, :float
    add_column :payrolls, :arl, :float
    add_column :payrolls, :compensation_fund, :float
    add_column :payrolls, :icbf, :float
    add_column :payrolls, :sena, :float
    add_column :payrolls, :severance_pay, :float
    add_column :payrolls, :interest_on_severance_pay, :float
    add_column :payrolls, :service_bonus, :float
    add_column :payrolls, :vacation, :float
    add_column :payrolls, :company_total_cost, :float
  end
end
