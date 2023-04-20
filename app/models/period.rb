class Period < ApplicationRecord
  belongs_to :company

  has_many :payrolls, dependent: :destroy

  validates :start_date, presence: true
  validates :end_date, presence: true


  def duration_in_days
    (end_date.to_date - start_date.to_date).to_i
  end

  private 

  def start_date_before_end_date; end

  # TODO Los periodos deben de ser unicos POR EMPRESA
end
