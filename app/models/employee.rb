class Employee < ApplicationRecord
  include StringValidations

  belongs_to :company

  has_many :payrolls, dependent: :destroy

  validates :name, :lastname, presence: true
  validates :name, :lastname, length: { minimun: 3, maximum: 20 }
  validates :name, :lastname, format: { with: proc { |w| w.regex_valid_string } }
  validates_numericality_of :salary, allow_nil: true, decimal: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  private 

  def start_date_before_end_date; end
end
