class CreatePaymentOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_options do |t|
      t.references :debt, null: false, foreign_key: true
      t.integer :total_monthly_payment
      t.date :final_payment_date
      t.boolean :active_plan
      t.integer :monthly_payment_principal

      t.timestamps
    end
  end
end
