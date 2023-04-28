class CreateSalaries < ActiveRecord::Migration[7.0]
  def change
    create_table :salaries do |t|
      t.decimal :value
      t.date :start_date
      t.date :end_date
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
