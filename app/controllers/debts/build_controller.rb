class Debts::BuildController < ApplicationController
  before_action :skip_authorization
  include Wicked::Wizard


  steps :add_name, :add_interest_rate, :add_monthly_principal_amount, :add_remaining_principal, :add_original_principal, :add_income, :add_expense, :add_debt_due_date

  def show
    @debt = Debt.find(params[:debt_id])
    render_wizard
  end

  def update
    @debt = Debt.find(params[:debt_id])
    params[:debt][:status] = step.to_s
    params[:debt][:status] = 'active' if step == steps.last
    @debt.update(debt_params)
    render_wizard @debt
  end

  def finish_wizard_path
    @debt.create_payment_options
    debt_path(@debt)
  end

  def new
    @debt = Debt.find(params[:debt_id])
    authorize @debt
    redirect_to wizard_path(steps.first)
  end

  private
  def debt_params
    params.require(:debt).permit(:name, :interest_rate, :remaining_principal,
       :original_principal, :income,
        :expense, :debt_due_date, :user_id, :monthly_principal_amount, :status)
  end
end
# Debt.create!(name: "test", interest_rate: 10, monthly_principal_amount: 1000, remaining_principal: 10000, original_principal: 10000, income: 100000, expense: 1000, debt_due_date: "2028-08-15", status: "active")
