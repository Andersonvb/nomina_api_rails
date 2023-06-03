class Salary < ApplicationRecord
  belongs_to :employee

  before_validation :set_start_date
  before_validation :set_end_date

  validates :value, presence: true
  validate :start_date_before_end_date
  validate :no_overlap
  validate :no_nested_salaries
  validate :within_employment_period

  private 

  def set_start_date
    if self.start_date.nil?
      before_salary = self.employee.salaries.where("end_date < ?", self.end_date).order(:end_date).last
      
      self.start_date = before_salary.end_date + 1
    end
  end

  def set_end_date
    if self.end_date.nil?
      next_salary = self.employee.salaries.where("start_date > ?", self.start_date).order(:start_date).first

      next_salary.nil? ? self.end_date = self.employee.end_date : self.end_date = next_salary.start_date - 1
    end
  end

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
    if employee.salaries.where.not(id: id).where("start_date < ? AND end_date > ?", start_date, end_date).exists?
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
