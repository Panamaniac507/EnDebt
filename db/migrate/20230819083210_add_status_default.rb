class AddStatusDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :debts, :status, :string, default: "active"
  end
end
