class Period < ApplicationRecord
  belongs_to :company

  has_many :payrolls, dependent: :destroy

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_date, uniqueness: { scope: [:end_date, :company_id], message: "ya existe un período con estas fechas para esta compañía" }
  validate :start_date_before_end_date


  def duration_in_days
    (end_date.to_date - start_date.to_date).to_i
  end

  private 

  def start_date_before_end_date
    errors.add(:start_date, "debe ser anterior a la fecha de finalización") if start_date >= end_date
  end

end
