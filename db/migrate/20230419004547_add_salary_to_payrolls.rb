class AddSalaryToPayrolls < ActiveRecord::Migration[7.0]
  def change
    add_column :payrolls, :salary, :float
  end
end
