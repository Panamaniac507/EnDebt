class ChangeActiveToBuilding < ActiveRecord::Migration[7.0]
  def change
    change_column :debts, :status, :string, default: "building"
  end
end
