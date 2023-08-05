class Debt < ApplicationRecord
  belongs_to :user
  has_many :payment_options
  validates :name, presence: true
  validates :interest_rate, presence: true
  validates :original_principal, presence: true
  validates :remaining_principal, presence: true
  validates :expense, presence: true
  validates :income, presence: true
end
