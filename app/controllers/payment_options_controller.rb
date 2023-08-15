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
    redirect_to payment_options_dashboard_path
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
    @debts = current_user.debts
    @debt = @debts[0]
    @payment_options = current_user.payment_options
    @selected_payment_options = @payment_options.where(active_plan: true)
    # @payment_options.each do |option|
    #   if option.active_plan == true
    #     @selected_option = option
    #   else
    #     # render payment_options page
    #   end
    # end
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
