class AddIncomeToDebts < ActiveRecord::Migration[7.0]
  def change
    add_column :debts, :income, :integer
  end
end
