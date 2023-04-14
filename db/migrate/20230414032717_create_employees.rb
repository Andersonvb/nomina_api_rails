class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.string :lastname
      t.decimal :salary
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
