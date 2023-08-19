class Debt < ApplicationRecord
  belongs_to :user
  has_many :payment_options
  validates :name, presence: true, if: :active_or_name?
  validates :interest_rate, presence: true, if: :active_or_interest_rate?
  validates :original_principal, presence: true, if: :active_or_original_principal?
  validates :remaining_principal, presence: true, if: :active_remaining_principal?
  validates :expense, presence: true, if: :active_or_expense?
  validates :income, presence: true, if: :active_or_income?
  validates :debt_due_date, presence: true, if: :active_or_debt_due_date?

  before_create :active?
  after_create :create_payment_options

  private
# the below is to be able to create our debt profile parameter by parameter
  def active?
    status == 'active'
  end

  def active_or_name?
    status.include?('name') || active?
  end

  def active_or_interest_rate?
    status.include?('interest_rate') || active?
  end

  def active_or_original_principal?
    status.include?('original_principal') || active?
  end

  def active_or_remaining_principal?
    status.include?('remaining_principal') || active?
  end

  def active_or_expense?
    status.include?('expense') || active?
  end

  def active_or_income?
    status.include?('income') || active?
  end

  def active_or_debt_due_date?
    status.include?('debt_due_date') || active?
  end

  # below is logic to create payment options object and payment object
  def create_payment_options
        if self.income < self.expense
          monthly_payment_principal_1 = 50
        else
          monthly_payment_principal_1 = 0.1 * self.income
          monthly_payment_principal_2 = 0.2 * self.income
          monthly_payment_principal_3 = 0.3 * self.income
        end

        monthly_payment_principal_1 = monthly_payment_principal_1.to_i
        monthly_payment_principal_2 = monthly_payment_principal_2.to_i
        monthly_payment_principal_3 = monthly_payment_principal_3.to_i

        # for debt breakdown
        monthly_payment_principal_0 = self.monthly_principal_amount

        # get "final_payment_date"
        num_month_payoff_1 = self.original_principal / monthly_payment_principal_1
        if num_month_payoff_1.is_a?(Float)
          num_month_payoff_1 = num_month_payoff_1.floor + 1
        end
        # month takes to finish payoff
        num_month_payoff_1 = num_month_payoff_1.to_i

        num_month_payoff_2 = self.original_principal / monthly_payment_principal_2
        if num_month_payoff_2.is_a?(Float)
          num_month_payoff_2 = num_month_payoff_2.floor + 1
        end
        # month takes to finish payoff
        num_month_payoff_2 = num_month_payoff_2.to_i

        num_month_payoff_3 = self.original_principal / monthly_payment_principal_3
        if num_month_payoff_3.is_a?(Float)
          num_month_payoff_3 = num_month_payoff_3.floor + 1
        end
        # month takes to finish payoff
        num_month_payoff_3 = num_month_payoff_3.to_i

        # get "final_payment_date" for debt breackdown
        num_month_payoff_0 = self.original_principal / monthly_payment_principal_0
        if num_month_payoff_0.is_a?(Float)
          num_month_payoff_0 = num_month_payoff_0.floor + 1
        end
        # month takes to finish payoff for debt breackdown
        num_month_payoff_0 = num_month_payoff_0.to_i

        original_date = Date.today
        original_date.change(day: self.debt_due_date.day)
        final_date_1 = original_date >> num_month_payoff_1
        final_date_2 = original_date >> num_month_payoff_2
        final_date_3 = original_date >> num_month_payoff_3
        # for debt breakdown
        final_date_0 = original_date >> num_month_payoff_0

        final_payment_date_1 = Date.new(final_date_1.year, final_date_1.month, self.debt_due_date.mday)
        final_payment_date_2 = Date.new(final_date_2.year, final_date_2.month, self.debt_due_date.mday)
        final_payment_date_3 = Date.new(final_date_3.year, final_date_3.month, self.debt_due_date.mday)
        # for debt breakdown
        final_payment_date_0 = Date.new(final_date_0.year, final_date_0.month, self.debt_due_date.mday)


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

        # for debt breakdown
        array_next_paying_date_0 = []
        today = Date.today
        today.change(day: self.debt_due_date.day)
        next_paying_date_0 = today >> 1
        num_month_payoff_0.times do |num|
          array_next_paying_date_0 << next_paying_date_0
          next_paying_date_0 = next_paying_date_0 >> 1
        end

        # get monthly interest amount
        array_interest_amount_1 = []
        monthly_interest_amount_1 = self.original_principal * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_1 << monthly_interest_amount_1.round
        remaining_principal_1 = self.original_principal - monthly_payment_principal_1
        monthly_interest_amount_1 = remaining_principal_1 * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_1 << monthly_interest_amount_1.round
        while (remaining_principal_1 - monthly_payment_principal_1) >= monthly_payment_principal_1
          remaining_principal_1 = remaining_principal_1 - monthly_payment_principal_1
          monthly_interest_amount_1 = remaining_principal_1 * (self.interest_rate / 100) * 30 / 365
          array_interest_amount_1 << monthly_interest_amount_1.round
        end
        if remaining_principal_1 > 0
          array_interest_amount_1 << (remaining_principal_1 * (self.interest_rate / 100) * 30 / 365).round
          last_monthly_principal_1 = remaining_principal_1
        end

        array_interest_amount_2 = []
        monthly_interest_amount_2 = self.original_principal * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_2 << monthly_interest_amount_2.round
        remaining_principal_2 = self.original_principal - monthly_payment_principal_2
        monthly_interest_amount_2 = remaining_principal_2 * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_2 << monthly_interest_amount_2.round
        while (remaining_principal_2 - monthly_payment_principal_2) >= monthly_payment_principal_2
          remaining_principal_2 = remaining_principal_2 - monthly_payment_principal_2
          monthly_interest_amount_2 = remaining_principal_2 * (self.interest_rate / 100) * 30 / 365
          array_interest_amount_2 << monthly_interest_amount_2.round
        end
        if remaining_principal_2 > 0
          array_interest_amount_2 << (remaining_principal_2 * (self.interest_rate / 100) * 30 / 365).round
          last_monthly_principal_2 = remaining_principal_2
        end

        array_interest_amount_3 = []
        monthly_interest_amount_3 = self.original_principal * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_3 << monthly_interest_amount_3.round
        remaining_principal_3 = self.original_principal - monthly_payment_principal_3
        monthly_interest_amount_3 = remaining_principal_3 * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_3 << monthly_interest_amount_3.round
        while (remaining_principal_3 - monthly_payment_principal_3) >= monthly_payment_principal_3
          remaining_principal_3 = remaining_principal_3 - monthly_payment_principal_3
          monthly_interest_amount_3 = remaining_principal_3 * (self.interest_rate / 100) * 30 / 365
          array_interest_amount_3 << monthly_interest_amount_3.round
        end
        if remaining_principal_3 > 0
          array_interest_amount_3 << (remaining_principal_3 * (self.interest_rate / 100) * 30 / 365).round
          last_monthly_principal_3 = remaining_principal_3
        end

        # for debt breakdown
        array_interest_amount_0 = []
        monthly_interest_amount_0 = self.original_principal * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_0 << monthly_interest_amount_0.round
        remaining_principal_0 = self.original_principal - monthly_payment_principal_0
        monthly_interest_amount_0 = remaining_principal_0 * (self.interest_rate / 100) * 30 / 365
        array_interest_amount_0 << monthly_interest_amount_0.round
        while (remaining_principal_0 - monthly_payment_principal_0) >= monthly_payment_principal_0
          remaining_principal_0 = remaining_principal_0 - monthly_payment_principal_0
          monthly_interest_amount_0 = remaining_principal_0 * (self.interest_rate / 100) * 30 / 365
          array_interest_amount_0 << monthly_interest_amount_0.round
        end
        if remaining_principal_0 > 0
          array_interest_amount_0 << (remaining_principal_0 * (self.interest_rate / 100) * 30 / 365).round
          last_monthly_principal_0 = remaining_principal_0
        end

        # get total monthly payment amount for each month
        array_total_monthly_payment_1 = []
        array_interest_amount_1.each do |amount|
          if array_interest_amount_1.last === amount && amount != monthly_payment_principal_1
            total_monthly_payment_1 = last_monthly_principal_1
          else
            total_monthly_payment_1 = amount + monthly_payment_principal_1
          end
          array_total_monthly_payment_1 << total_monthly_payment_1
          array_total_monthly_payment_1.compact!
        end

        array_total_monthly_payment_2 = []
        array_interest_amount_2.each do |amount|
          if array_interest_amount_2.last === amount && amount != monthly_payment_principal_2
            total_monthly_payment_2 = last_monthly_principal_2
          else
            total_monthly_payment_2 = amount + monthly_payment_principal_2
          end
          array_total_monthly_payment_2 << total_monthly_payment_2
          array_total_monthly_payment_2.compact!
        end

        array_total_monthly_payment_3 = []
        array_interest_amount_3.each do |amount|
          if array_interest_amount_3.last === amount && amount != monthly_payment_principal_3
            total_monthly_payment_3 = last_monthly_principal_3
          else
            total_monthly_payment_3 = amount + monthly_payment_principal_3
          end
          array_total_monthly_payment_3 << total_monthly_payment_3
          array_total_monthly_payment_3.compact!
        end

        # for debt breakdown
        array_total_monthly_payment_0 = []
        array_interest_amount_0.each do |amount|
          if array_interest_amount_0.last === amount && amount != monthly_payment_principal_0
            total_monthly_payment_0 = last_monthly_principal_0
          else
            total_monthly_payment_0 = amount + monthly_payment_principal_0
          end
          array_total_monthly_payment_0 << total_monthly_payment_0
          array_total_monthly_payment_0.compact!
        end


        # get total payment to payoff in total
        total_monthly_payment_1 = array_total_monthly_payment_1.sum
        total_monthly_payment_2 = array_total_monthly_payment_2.sum
        total_monthly_payment_3 = array_total_monthly_payment_3.sum
        # for debt breakdown
        total_monthly_payment_0 = array_total_monthly_payment_0.sum

        # get total payment of interest
        total_monthly_interest_payment_1 = array_interest_amount_1.sum
        total_monthly_interest_payment_2 = array_interest_amount_2.sum
        total_monthly_interest_payment_3 = array_interest_amount_3.sum
        # for debt breakdown
        total_monthly_interest_payment_0 = array_interest_amount_0.sum


        # create PaymentOption object
        payment_option_1 = PaymentOption.create!(total_monthly_payment: total_monthly_payment_1, total_interest_amount: total_monthly_interest_payment_1, final_payment_date: final_payment_date_1, active_plan: false, monthly_payment_principal: monthly_payment_principal_1, debt: self)
        payment_option_2 = PaymentOption.create!(total_monthly_payment: total_monthly_payment_2, total_interest_amount: total_monthly_interest_payment_2, final_payment_date: final_payment_date_2, active_plan: false, monthly_payment_principal: monthly_payment_principal_2, debt: self)
        payment_option_3 = PaymentOption.create!(total_monthly_payment: total_monthly_payment_3, total_interest_amount: total_monthly_interest_payment_3, final_payment_date: final_payment_date_3, active_plan: false, monthly_payment_principal: monthly_payment_principal_3, debt: self)
        # for debt breakdown
        payment_option_0 = PaymentOption.create!(total_monthly_payment: total_monthly_payment_0, total_interest_amount: total_monthly_interest_payment_0, final_payment_date: final_payment_date_0, active_plan: false, monthly_payment_principal: monthly_payment_principal_0, debt: self)


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
        end

        # set iteration
        num_month_payoff_2.times do |num|
          # get next payment amount
            data_next_payment_amount_2 = array_total_monthly_payment_2[num]
            data_next_paying_date_2 = array_next_paying_date_2[num]
            if num === 0
              status = true
            else
              status = false
            end
            Payment.create!(next_payment_amount: data_next_payment_amount_2, next_paying_date: data_next_paying_date_2, status: status, payment_option: payment_option_2)
          end

            # set iteration
        num_month_payoff_3.times do |num|
          # get next payment amount
            data_next_payment_amount_3 = array_total_monthly_payment_3[num]
            data_next_paying_date_3 = array_next_paying_date_3[num]
            if num === 0
              status = true
            else
              status = false
            end
            Payment.create!(next_payment_amount: data_next_payment_amount_3, next_paying_date: data_next_paying_date_3, status: status, payment_option: payment_option_3)
          end

          # set iteration for debt breakdown
          num_month_payoff_0.times do |num|
            # get next payment amount
              data_next_payment_amount_0 = array_total_monthly_payment_0[num]
              data_next_paying_date_0 = array_next_paying_date_0[num]
              if num === 0
                status = true
              else
                status = false
              end
              Payment.create!(next_payment_amount: data_next_payment_amount_0, next_paying_date: data_next_paying_date_0, status: status, payment_option: payment_option_0)
            end
  end
end
