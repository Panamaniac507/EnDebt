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
  end

  private

  def debt_params
    params.require(:debt).permit(:name, :interest_rate, :remaining_principal,
       :original_principal, :income,
        :expense, :debt_due_date, :user_id)
  end
end
