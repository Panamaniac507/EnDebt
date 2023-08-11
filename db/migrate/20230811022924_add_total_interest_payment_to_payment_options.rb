class AddTotalInterestPaymentToPaymentOptions < ActiveRecord::Migration[7.0]
  def change
    add_column :payment_options, :total_interest_amount, :integer
  end
end
