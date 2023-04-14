class Payroll < ApplicationRecord
  belongs_to :employee
  belongs_to :period

  validates :salary_income, presence: true
  validates :non_salary_income, presence: true
  validates :deductions, presence: true
  validates :transport_allowance, presence: true
  validates :net_pay, presence: true
end
