class Period < ApplicationRecord
  belongs_to :company

  has_many :payrolls

  validates :start_date, presence: true
  validates :end_date, presence: true

  private 

  def start_date_before_end_date; end
end
