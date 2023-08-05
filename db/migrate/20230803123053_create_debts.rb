class CreateDebts < ActiveRecord::Migration[7.0]
  def change
    create_table :debts do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.float :interest_rate
      t.integer :remaining_principal
      t.integer :original_principal

      t.timestamps
    end
  end
end
