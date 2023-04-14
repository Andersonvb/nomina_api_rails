class Employee < ApplicationRecord
  belongs_to :company

  has_many :payrolls

  validates :name, presence: true
  validates :name, length: { minimun: 3, maximum: 20 }
  validates :name, format: { with: /\A[a-zA-Z0-9_]+(?: [a-zA-Z0-9_]+)*\z/ }

  validates :lastname, presence: true
  validates :lastname, length: { minimun: 3, maximum: 20 }
  validates :lastname, format: { with: /\A[a-zA-Z0-9_]+(?: [a-zA-Z0-9_]+)*\z/ }

  validates_numericality_of :salary, allow_nil: true, decimal: true

  validates :start_date, presence: true
  validates :end_date, presence: true

  private 

  def start_date_before_end_date; end
end
