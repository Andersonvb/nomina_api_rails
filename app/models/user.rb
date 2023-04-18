class User < ApplicationRecord
  include StringValidations
  
  has_secure_password

  has_many :companies, dependent: :destroy

  validates :name, :lastname, :username, presence: true
  validates :name, :lastname, :username, length: { minimun: 3, maximum: 20 }
  validates :name, :lastname, :username, format: { with: proc { |w| w.regex_valid_string } }
  validates :username, uniqueness: true
end
