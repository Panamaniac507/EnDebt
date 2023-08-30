import { Controller } from "@hotwired/stimulus"
import { Popover } from "bootstrap";
// Connects to data-controller="popover"
export default class extends Controller {
  connect() {
     let message
     if(this.element.classList.contains("add_due_date"))
      {message = "You will never walk alone, EnDebt will sort You Out!"}
      else if (this.element.classList.contains("add_pop"))
      {message = "Ask contact"}
      else if (this.element.classList.contains("original1")){
        message = "Principal is the actual amount of money you borrow which doesn't contain the interest. You need to pay off aside from interest amount"
      }
      else if (this.element.classList.contains("expense1")){
        message = "Expenses refer to your monthly expenses "
      }
      else if (this.element.classList.contains("income1")){
        message = "Income refers to your monthly income"
      }
      else if (this.element.classList.contains("interest1")){
        message = "Interest rate is the monetary charge for borrowing money expressed as a percentage"}
      else if (this.element.classList.contains("monthlyp1")){
        message = "The amount of money you need to payoff monthly for principal, which is sum of original principal and interest amount"}
      else if (this.element.classList.contains("remai1")){
        message = "The remaining amount of money you borrow, which you need to pay off aside from interest amount"}
      else if (this.element.classList.contains("original_principal")){
        message = "Principal is the actual amount of money you borrow which doesn't contain the interest. You need to pay off aside from interest amount"
      }
      else if (this.element.classList.contains("remaining_principal")){
        message = "The remaining amount of money you borrow, which you need to pay off aside from interest amount"
      }
      else if (this.element.classList.contains("total_payment_amount")){
        message = "The amount of money you need to payoff in total through your journey, which is sum of original principal and interest amount"
      }
      else if (this.element.classList.contains("insterest_amount")){
        message = "Interest amount is the amount of money you need to pay aside from principal. interest is % mulitpled against remaining principal every month and this money is the Biggest issue which prevent you from paying off."
      }
      else if (this.element.classList.contains("monthly_principal")){
        message = "The amount of money you need to payoff monthly for principal, which is sum of original principal and interest amount"
      }
      else if (this.element.classList.contains("final_due_date")){
        message = "The date you will pay off your debt at this rate"
      }
      else {message = "The first step is always the hardest, you got this!."}
      this.popover = new Popover(this.element, {
      content: message,
      trigger: "click", // Show popover on click
      placement: "right"
    });
  }
}
