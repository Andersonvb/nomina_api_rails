class RemoveSalaryFromEmployees < ActiveRecord::Migration[7.0]
  def change
    remove_column :employees, :salary, :decimal
  end
end
