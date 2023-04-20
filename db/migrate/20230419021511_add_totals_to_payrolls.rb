class AddTotalsToPayrolls < ActiveRecord::Migration[7.0]
  def change
    add_column :payrolls, :total_withholdings_and_deductions, :float
    add_column :payrolls, :total_social_security, :float
    add_column :payrolls, :total_parafiscal_contributions, :float
    add_column :payrolls, :total_social_benefits, :float
  end
end
