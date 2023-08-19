class Debts::BuildController < ApplicationController
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
    @debt.update_attributes(params[:debt])
    render_wizard @debt
  end

  def create
    @debt = Debt.create
    redirect_to wizard_path(steps.first, debt_id: @debt.id)
  end
end
