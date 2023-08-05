class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :payment_option, null: false, foreign_key: true
      t.integer :next_payment_amount
      t.date :next_paying_date

      t.timestamps
    end
  end
end
