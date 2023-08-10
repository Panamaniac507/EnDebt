class Debt < ApplicationRecord
  belongs_to :user
  has_many :payment_options
  validates :name, presence: true
  validates :interest_rate, presence: true
  validates :original_principal, presence: true
  validates :remaining_principal, presence: true
  validates :expense, presence: true
  validates :income, presence: true
  validates :debt_due_date, presence: true

  after_create :create_payment_options

  private
  # below is logic to create payment options object and payment object
  def create_payment_options
        if self.income < self.expense
          monthly_payment_principal_1 = 50
        else
          monthly_payment_principal_1 = 0.1 * self.income
          monthly_payment_principal_2 = 0.2 * self.income
          monthly_payment_principal_3 = 0.3 * self.income
        end

        # get "final_payment_date"
        num_month_payoff_1 = self.original_principal / monthly_payment_principal_1
        if num_month_payoff_1%2 != 0
          num_month_payoff_1 = num_month_payoff_1.floor + 1
        end
        # month takes to finish payoff
        num_month_payoff_1 = num_month_payoff_1.to_i

        num_month_payoff_2 = self.original_principal / monthly_payment_principal_2
        if num_month_payoff_2%2 != 0
          num_month_payoff_2 = num_month_payoff_2.floor + 1
        end
        # month takes to finish payoff
        num_month_payoff_2 = num_month_payoff_2.to_i

        num_month_payoff_3 = self.original_principal / monthly_payment_principal_3
        if num_month_payoff_3%2 != 0
          num_month_payoff_3 = num_month_payoff_3.floor + 1
        end
        # month takes to finish payoff
        num_month_payoff_3 = num_month_payoff_3.to_i

        original_date = Date.today
        original_date.change(day: self.debt_due_date.day)
        final_date_1 = original_date >> num_month_payoff_1
        final_date_2 = original_date >> num_month_payoff_2
        final_date_3 = original_date >> num_month_payoff_3

        final_payment_date_1 = Date.new(final_date_1.year, final_date_1.month, self.debt_due_date.mday)
        final_payment_date_2 = Date.new(final_date_2.year, final_date_2.month, self.debt_due_date.mday)
        final_payment_date_3 = Date.new(final_date_3.year, final_date_3.month, self.debt_due_date.mday)


        # get next payment date
        array_next_paying_date_1 = []
        today = Date.today
        today.change(day: self.debt_due_date.day)
        next_paying_date_1 = today >> 1
        num_month_payoff_1.times do |num|
          array_next_paying_date_1 << next_paying_date_1
          next_paying_date_1 = next_paying_date_1 >> 1
        end

        array_next_paying_date_2 = []
        today = Date.today
        today.change(day: self.debt_due_date.day)
        next_paying_date_2 = today >> 1
        num_month_payoff_2.times do |num|
          array_next_paying_date_2 << next_paying_date_2
          next_paying_date_2 = next_paying_date_2 >> 1
        end

        array_next_paying_date_3 = []
        today = Date.today
        today.change(day: self.debt_due_date.day)
        next_paying_date_3 = today >> 1
        num_month_payoff_3.times do |num|
          array_next_paying_date_3 << next_paying_date_3
          next_paying_date_3 = next_paying_date_3 >> 1
        end

        # get monthly interest amount
        array_interest_amount_1 = []
        monthly_interest_amount_1 = self.original_principal * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_1 << monthly_interest_amount_1
        remaining_principal_1 = self.original_principal - monthly_payment_principal_1
        monthly_interest_amount_1 = remaining_principal_1 * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_1 << monthly_interest_amount_1
        until remaining_principal_1 >= monthly_payment_principal_1
          monthly_interest_amount_1 = remaining_principal_1 * (self.interest_rate / 100) * 30 / 365
          array_interest_amount_1 << monthly_interest_amount_1
        end
        if remaining_principal_1 > 0
          array_interest_amount_1 << remaining_principal_1
        end

        array_interest_amount_2 = []
        monthly_interest_amount_2 = self.original_principal * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_2 << monthly_interest_amount_2
        remaining_principal_2 = self.original_principal - monthly_payment_principal_2
        monthly_interest_amount_2 = remaining_principal_2 * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_2 << monthly_interest_amount_2
        until remaining_principal_2 >= monthly_payment_principal_2
          monthly_interest_amount_2 = remaining_principal_2 * (self.interest_rate / 100) * 30 / 365
          array_interest_amount_2 << monthly_interest_amount_2
        end
        if remaining_principal_2 > 0
          array_interest_amount_2 << remaining_principal_2
        end

        array_interest_amount_3 = []
        monthly_interest_amount_3 = self.original_principal * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_3 << monthly_interest_amount_3
        remaining_principal_3 = self.original_principal - monthly_payment_principal_3
        monthly_interest_amount_3 = remaining_principal_3 * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_3 << monthly_interest_amount_3
        until remaining_principal_3 >= monthly_payment_principal_3
          monthly_interest_amount_3 = remaining_principal_3 * (self.interest_rate / 100) * 30 / 365
          array_interest_amount_3 << monthly_interest_amount_3
        end
        if remaining_principal_3 > 0
          array_interest_amount_3 << remaining_principal_3
        end

        # get total monthly payment amount for each month
        array_total_monthly_payment_1 = []
        array_interest_amount_1.each do |amount|
          total_monthly_payment = amount + monthly_payment_principal_1
          array_total_monthly_payment_1 << total_monthly_payment
        end

        array_total_monthly_payment_2 = []
        array_interest_amount_2.each do |amount|
          total_monthly_payment = amount + monthly_payment_principal_2
          array_total_monthly_payment_2 << total_monthly_payment
        end

        array_total_monthly_payment_3 = []
        array_interest_amount_3.each do |amount|
          total_monthly_payment = amount + monthly_payment_principal_3
          array_total_monthly_payment_3 << total_monthly_payment
        end

        # get total payment to payoff in total
        total_monthly_payment_1 = array_total_monthly_payment_1.sum
        total_monthly_payment_2 = array_total_monthly_payment_2.sum
        total_monthly_payment_3 = array_total_monthly_payment_3.sum

        # get total payment of interest
        total_monthly_interest_payment_1 = array_interest_amount_1.sum
        total_monthly_interest_payment_2 = array_interest_amount_2.sum
        total_monthly_interest_payment_3 = array_interest_amount_3.sum

        # create PaymentOption object
        payment_option_1 = PaymentOption.create!(total_monthly_payment: total_monthly_payment_1, final_payment_date: final_payment_date_1, active_plan: false, monthly_payment_principal: monthly_payment_principal_1, debt: self)
        payment_option_2 = PaymentOption.create!(total_monthly_payment: total_monthly_payment_2, final_payment_date: final_payment_date_2, active_plan: false, monthly_payment_principal: monthly_payment_principal_2, debt: self)
        payment_option_3 = PaymentOption.create!(total_monthly_payment: total_monthly_payment_3, final_payment_date: final_payment_date_3, active_plan: false, monthly_payment_principal: monthly_payment_principal_3, debt: self)


        # Create payment objects

        # set iteration
        num_month_payoff_1.times do |num|
        # get next payment amount
          data_next_payment_amount_1 = array_total_monthly_payment_1[num]
          data_next_paying_date_1 = array_next_paying_date_1[num]
          if num === 0
            status = true
          else
            status = false
          end
          Payment.create!(next_payment_amount: data_next_payment_amount_1, next_paying_date: data_next_paying_date_1, status: status, payment_option: payment_option_1)
          # Payment.create!(next_payment_amount: data_next_payment_amount_1, next_paying_date: data_next_paying_date_1, status: status, payment_option: payment_option_2)
          # Payment.create!(next_payment_amount: data_next_payment_amount_1, next_paying_date: data_next_paying_date_1, status: status, payment_option: payment_option_3)
        end



        # create_table "payments", force: :cascade do |t|
        #   t.bigint "payment_option_id", null: false
        #   t.integer "next_payment_amount"
        #   t.date "next_paying_date"
        #   t.datetime "created_at", null: false
        #   t.datetime "updated_at", null: false
        #   t.integer "status"
        #   t.index ["payment_option_id"], name: "index_payments_on_payment_option_id"
        # end

  end
end
    # Services::PaymentOptions.create(self)
#   end
# end
