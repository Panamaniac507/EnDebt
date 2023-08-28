class PaymentOptionsController < ApplicationController
  def show
    @debt = Debt.find(params[:debt_id])
    authorize @debt
  end

  def new
    @payment_option = Payment_option.new
    authorize @payment_option
    @current_user = current_user
  end

  def choose
    # add policy pundit later
    skip_authorization
    @payment_option_selected = PaymentOption.find(params[:id])
    @payment_option_selected.update(active_plan: true)
    redirect_to payment_options_dashboard_path(debt_id: @payment_option_selected.debt_id)
  end

  def create
    @debt = Debt.find(params[:debt_id])
    @payment_option = Payment_option.new(payment_option_params)
    @payment_option.user = current_user
    @payment_option.debt = @debt
    authorize @payment_option
    if @payment_option.save
      redirect_to payment_options_dashboard_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def dashboard
    # Logic to retrieve payment options for the current user
    # in the future, we will have several debts therefore line 26.
    # add policy pundit later
    skip_authorization

    # scope = Debt.all

    # scope = scope.where(critria) if params[:criteria]

    @paid = true if params[:payment]

    @debt = Debt.find(params[:debt_id])
    # @debts = current_user.debts
    # @debt = @debts[0]
    @payment_options = @debt.payment_options
    @selected_payment_options = @payment_options.where(active_plan: true)
    # @payment_options.each do |option|
    #   if option.active_plan == true
    #     @selected_option = option
    #   else
    #     # render payment_options page
    #   end
    # end
  # # stacked column chart for total---
    @debt_p_total = [@debt.original_principal]
    @debt_i_total = [@selected_payment_options[0].total_interest_amount]

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
    @selected_payment_options[0].payments.each do |payment|
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
    @selected_payment_options[0].payments.each do |payment|
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

  end

  def paid
    skip_authorization

    @debt = Debt.find(params[:debt_id])
    # @debts = current_user.debts
    # @debt = @debts[0]
    @payment_options = @debt.payment_options
    @selected_payment_options = @payment_options.where(active_plan: true)
    payment_id = 0
    @selected_payment_options[0].payments.each do |payment|
      if payment.status == 1
        @payment_update = Payment.find(payment.id)
        payment_id = @payment_update.id + 1
        if payment_id
          @next = Payment.find(payment_id)
          if @next.payment_option.debt_id == @debt.id
            @next.update(status: 1)
            @payment_update.update(status: 2)
            remain = @debt.remaining_principal - @selected_payment_options[0].monthly_payment_principal
            @debt.update(remaining_principal: remain)
          else
            @payment_update.update(status: 3)
            remain = 0
            @update.update(remaining_principal: remain)
          end
        else
          @payment_update.update(status: 3)
          remain = 0
          @debt.update(remaining_principal: remain)
        end
      end
    end
      # selected_debt = Debt.find(@selected_payment_options[0].debt_id)
      # debt = @selected_payment_options[0].debt_id
      # debt.update(remaining_principal: remain)
    redirect_to payment_options_dashboard_path(debt_id: @debt.id, payment: true)
  end

  # def show
  #   @payment_options = Payment_option.find(params[:id])
  # end

  def delete
    @payment_options = Payment_option.find(params[:id])
    authorize @payment_options
    @payment_options.destroy
  end

  private

  def payment_option_params
    params.require(:payment_option).permit(
      :total_monthly_payment,
      :final_payment_date,
      :active_plan,
      :monthly_payment_principal,
      :total_interest_amount
    )
  end
end
