class Payroll < ApplicationRecord
  belongs_to :employee
  belongs_to :period

  validates :salary_income, :non_salary_income, :deductions, presence: true
  validates :period_id, uniqueness: { scope: :employee_id, message: "Ya existe una nómina para este período y empleado" }
end
