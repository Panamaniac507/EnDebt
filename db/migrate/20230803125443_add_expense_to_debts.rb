class AddExpenseToDebts < ActiveRecord::Migration[7.0]
  def change
    add_column :debts, :expense, :integer
  end
end
