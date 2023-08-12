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
    i = 0
    # line 30 should be the actual number of payments
    # with the original number of monthly payments
    # 12 below is just for testing purposes.
    12.times do
      @original_payments[Date.today + i.months] = @debt.monthly_principal_ammount
      i += 1
    end
    # {@debt.monthly_principal_ammount}
  end

  private

  def debt_params
    params.require(:debt).permit(:name, :interest_rate, :remaining_principal,
       :original_principal, :income,
        :expense, :debt_due_date, :user_id, :monthly_principal_amount)
  end
end
