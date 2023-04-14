class CreatePayrolls < ActiveRecord::Migration[7.0]
  def change
    create_table :payrolls do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :period, null: false, foreign_key: true
      t.decimal :salary_income
      t.decimal :non_salary_income
      t.decimal :deductions
      t.decimal :transport_allowance
      t.decimal :net_pay

      t.timestamps
    end
  end
end
