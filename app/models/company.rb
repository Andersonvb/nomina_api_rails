class Company < ApplicationRecord
  include StringValidations

  belongs_to :user

  has_many :periods, dependent: :destroy
  has_many :employees, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { minimum: 3, maximum: 20 }
  validates :name, format: { with: proc { |w| w.regex_valid_string } }

  scope :user_companies, ->(user_id) { where(user_id: user_id) }
end
