class PaymentOptionsController < ApplicationController

  def show
    @debt = Debt.find(params[:debt_id])
  end

  def new
    @payment_option = Payment_option.new
    @current_user = current_user
  end

  def create
    @debt = Debt.find(params[:debt_id])
    @payment_option = Payment_option.new(payment_option_params)
    @payment_option.user = current_user
    @payment_option.debt = @debt
    if @payment_option.save
      redirect_to payment_options_dashboard_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def dashboard
    # Logic to retrieve payment options for the current user
    # in the future, we will have several debts therefore line 27.
    @debts = current_user.debts
  end

  def show
    @payment_options = Payment_option.find(params[:id])
  end

  def delete
    @payment_options = Payment_option.find(params[:id])
    @payment_options.destroy
  end

  private

  def payment_option_params
    params.require(:payment_option).permit(
      :total_monthly_payment,
      :final_payment_date,
      :active_plan,
      :monthly_payment_principal
    )
  end
end
