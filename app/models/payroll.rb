class Payroll < ApplicationRecord
  belongs_to :employee
  belongs_to :period

  validates :salary_income, :non_salary_income, :deductions, :transport_allowance, :net_pay, presence: true
end
