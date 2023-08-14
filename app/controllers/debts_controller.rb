class DebtsController < ApplicationController
  def new
    @debt = Debt.new
    authorize @debt
  end

  def create
    @debt = Debt.new(debt_params)
    @debt.remaining_principal = debt_params[:original_principal]
    @debt.user = current_user
    authorize @debt
    if @debt.save
      redirect_to debt_path(@debt)
    else
      render :new, status: :unprocessable_entity
    end
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

    # stacked column chart---
    @data_monthly_principal = []
    @payment_options[3].payments.each do |payment|
      @data_monthly_principal << [payment.next_paying_date, @debt.monthly_principal_amount]
    end

    @data_monthly_interest = []
    @payment_options[3].payments.each do |payment|
      @data_monthly_interest << [payment.next_paying_date, (payment.next_payment_amount - @debt.monthly_principal_amount)]
    end

    @data_all = [
      {
        name: "Monthly principal",
        data: @data_monthly_principal
      },
      {
        name: "Monthly interest",
        data: @data_monthly_interest
      }
    ]
  end
    # stacked column chart---end

  private

  def debt_params
    params.require(:debt).permit(:name, :interest_rate, :remaining_principal,
       :original_principal, :income,
        :expense, :debt_due_date, :user_id, :monthly_principal_amount)
  end
end
