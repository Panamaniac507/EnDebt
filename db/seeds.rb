# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

p "rails seed start"

user1 = User.create!(
  email: 'testseed@test.com',
  password: 'password'
)

debt1 = Debt.create!(
  name: 'Ken',
  original_principal: 2_000_000,
  remaining_principal: 70_000,
  interest_rate: 15,
  income: 300_000,
  expense: 200_000,
  monthly_principal_amount: 20_000,
  debt_due_date: Date.new(2023,9,1),
  user_id: user1.id
)

paymentoption1 = PaymentOption.create!(
  total_monthly_payment: 3_245_306,
  debt_id: debt1.id,
  final_payment_date: Date.new(2023,9,1),
  active_plan: true,
  monthly_payment_principal: 20_000,
  total_interest_amount: 1_245_206
)

3.times do
 PaymentOption.create!(
  total_monthly_payment: 3_245_306,
  debt_id: debt1.id,
  final_payment_date: Date.new(2023,9,1),
  active_plan: false,
  monthly_payment_principal: 20_000,
  total_interest_amount: 1_245_206
)
end

payment1 = Payment.create!(
  payment_option_id: paymentoption1.id,
  next_payment_amount: 20_000,
  next_paying_date: Date.new(2023,9,1),
  status: 1
)

p "rails seed end"
