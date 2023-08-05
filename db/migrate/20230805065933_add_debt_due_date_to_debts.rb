class AddDebtDueDateToDebts < ActiveRecord::Migration[7.0]
  def change
    add_column :debts, :debt_due_date, :date
  end
end
