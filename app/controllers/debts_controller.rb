class DebtsController < ApplicationController

  def new
    @debt = Debt.new
  end

  def create
    @debt = Debt.new(debt_params)
    @debt.user = current_user
    if @debt.save
      redirect_to payment_options_dashboard_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @debt = Debt.find(params[:id])
  end

  private

  def debt_params
    params.require(:debt).permit(:name, :interest_rate, :remaining_principal, :original_principal, :income, :expense)
  end
end
