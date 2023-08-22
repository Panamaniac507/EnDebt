class AddStatusDefault < ActiveRecord::Migration[7.0]
  def change
    add_column :debts, :status, :string, default: "active"
  end
end
