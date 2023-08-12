class AddMonthlyPrincipalAmountToDebts < ActiveRecord::Migration[7.0]
  def change
    add_column :debts, :monthly_principal_amount, :integer
  end
end
