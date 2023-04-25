class Employee < ApplicationRecord
  include StringValidations

  belongs_to :company

  has_many :payrolls, dependent: :destroy

  validates :name, :lastname, :salary, presence: true
  validates :name, :lastname, length: { minimum: 3, maximum: 20 }
  validates :name, :lastname, format: { with: proc { |w| w.regex_valid_string } }
  validates_numericality_of :salary,  decimal: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :start_date_before_end_date

  private 

  def start_date_before_end_date
    return if start_date.nil?
    return if end_date.nil?

    errors.add(:start_date, "debe ser anterior a la fecha de finalización") if start_date >= end_date
  end
end
