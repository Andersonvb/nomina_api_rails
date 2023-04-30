class Salary < ApplicationRecord
  belongs_to :employee

  validates :value, :start_date, :end_date, presence: true
  validate :start_date_before_end_date
  validate :no_overlap
  validate :no_nested_salaries
  validate :within_employment_period

  private 

  def start_date_before_end_date
    return if start_date.nil?
    return if end_date.nil?

    errors.add(:start_date, "debe ser anterior a la fecha de finalización") if start_date >= end_date
  end

  def no_overlap
    if employee.salaries.where.not(id: id).where("(? BETWEEN start_date AND end_date) OR (? BETWEEN start_date AND end_date)", start_date, end_date).exists?
      errors.add(:base, "El empleado no puede tener dos salarios en la misma fecha")
    end
  end

  def no_nested_salaries
    if employee.salaries.where.not(id: id).where("start_date < ? AND end_date > ?", end_date, start_date).exists?
      errors.add(:base, "El empleado no puede tener un salario dentro de otro")
    end
  end

  def within_employment_period
    return if start_date.nil?
    return if end_date.nil?

    if start_date < employee.start_date || end_date > employee.end_date
      errors.add(:base, "El salario no puede estar fuera del período de empleo del empleado")
    end
  end
end
