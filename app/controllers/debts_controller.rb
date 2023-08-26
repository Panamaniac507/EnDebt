class DebtsController < ApplicationController
  before_action :skip_authorization

  # def new
  #   @debt = Debt.new
  #   authorize @debt
  # end

  def index
      user = User.find(current_user.id)
      # @debts = user.debts
      # @debts.each do |debt|
      # @debt = debt
      # authorize @debt
      # end
      @debts = policy_scope(user.debts)
  end

  def new
    @debt = Debt.new
    # @debt.remaining_principal = debt_params[:original_principal]
    @debt.user = current_user
    @debt.status = 'building'
    @debt.save
    authorize @debt
    redirect_to new_debt_build_path(@debt)
  end

  def show
    @debt = Debt.find(params[:id])
    authorize @debt
    # get payment options create
    @payment_options = @debt.payment_options
    @payment_option = @debt.payment_options.where(active_plan: true).first
    @original_payments = {}
    @monthly_interests = {}
    i = 0
    # line 30 should be the actual number of payments
    # with the original number of monthly payments
    # 12 below is just for testing purposes.
    @payment_options[3].payments.count.times do
      @original_payments[Date.today + i.months] = @debt.monthly_principal_amount
      i += 1
    end
    # {@debt.monthly_principal_ammount}
    @payment = []
    @payment_options[3].payments.each do |item|
      @payment << item
    end
    j = 0
    (@payment_options[3].payments.count-2).times do
      monthly_interest_amount = @payment[j].next_payment_amount - @debt.monthly_principal_amount
      @monthly_interests[Date.today + j.months] = monthly_interest_amount
      j += 1
    end

    # # stacked column chart for total---
    @debt_p_total = [@debt.original_principal]
    @debt_i_total = [@payment_options[3].total_interest_amount]

    @data_total = [
      {
        name: "Principal Amount",
        data: [["",@debt_p_total]]
      },
      {
        name: "Interest Amount",
        data: [["",@debt_i_total]]
      }
    ]

    # stacked column chart---
    @data_monthly_principal = []
    @data_monthly_principal_short = []
    @payment_options[3].payments.each do |payment|
      @data_monthly_principal << [payment.next_paying_date, @debt.monthly_principal_amount]
    end
    num = (@data_monthly_principal.count / 5)
    count = 0
    5.times do |n|
      @data_monthly_principal_short << @data_monthly_principal[count]
      count += num
    end

    @data_monthly_interest = []
    @data_monthly_interest_short = []
    @payment_options[3].payments.each do |payment|
      @data_monthly_interest << [payment.next_paying_date, (payment.next_payment_amount - @debt.monthly_principal_amount)]
    end
    num = (@data_monthly_interest.count / 5)
    count = 0
    5.times do |n|
      @data_monthly_interest_short << @data_monthly_interest[count]
      count += num
    end

    @data_all = [
      {
        name: "Monthly payment amount for principal",
        data: @data_monthly_principal_short
      },
      {
        name: "Monthly payment amount for interest",
        data: @data_monthly_interest_short
      }
    ]

    # pie chart for progress
    @progress_data =
      {
        "Payment Done": 20, "Payment Not Done":60
      }



    # # stacked column chart for showing balance of principal and interest---


    # for plan1
    @debt_p_plan_1 = [@debt.original_principal]
    @debt_i_plan_1 = [@payment_options[0].total_interest_amount]

    @data_plan_1 = [
      {
        name: "Principal Amount",
        data: [["Minimum Plan",@debt_p_plan_1]]
      },
      {
        name: "Interest Amount",
        data: [["Minimun Plan",@debt_i_plan_1]]
      }
    ]

    # for plan2
    @debt_p_plan_2 = [@debt.original_principal]
    @debt_i_plan_2 = [@payment_options[1].total_interest_amount]

    @data_plan_2 = [
      {
        name: "Principal Amount",
        data: [["Standard Plan",@debt_p_plan_2]]
      },
      {
        name: "Interest Amount",
        data: [["Standard Plan",@debt_i_plan_2]]
      }
    ]

    # for plan3
    @debt_p_plan_3 = [@debt.original_principal]
    @debt_i_plan_3 = [@payment_options[2].total_interest_amount]

    @data_plan_3 = [
      {
        name: "Principal Amount",
        data: [["Super Plan",@debt_p_plan_3]]
      },
      {
        name: "Interest Amount",
        data: [["Super Plan",@debt_i_plan_3]]
      }
    ]

    # for comparison

    @debt_p_original = [@debt.original_principal]
    @debt_i_original = [@payment_options[3].total_interest_amount]

    @data_compare = [
      {
        name: "Principal Amount",
        data: [["Original Plan",@debt_p_original],["Minimum Plan",@debt_p_plan_1], ["Standard Plan",@debt_p_plan_2],["Super Plan",@debt_p_plan_3]]
      },
      {
        name: "Interest Amount",
        data: [["Original Plan",@debt_i_original],["Minimum Plan",@debt_i_plan_1], ["Standard Plan",@debt_i_plan_2],["Super Plan",@debt_i_plan_3]]
      }
    ]
    #to call chatgpt, should NOT run it if it is required as it costs
    # @response = OpenaiService.new('what is debt?').call

  end

  private

  # def debt_params
  #   params.require(:debt).permit(:name, :interest_rate, :remaining_principal,
  #      :original_principal, :income,
  #       :expense, :debt_due_date, :user_id, :monthly_principal_amount, :status)
  # end
end
