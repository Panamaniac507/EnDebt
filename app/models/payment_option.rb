class PaymentOption < ApplicationRecord
  belongs_to :debt
  has_many :payments
end
