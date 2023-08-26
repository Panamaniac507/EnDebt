import { Controller } from "@hotwired/stimulus"
import { Popover } from "bootstrap";
// Connects to data-controller="popover"
export default class extends Controller {
  connect() {
     let message
     if(this.element.classList.contains("add_due_date"))
      {message = "You will never walk alone, EnDebt will sort You Out!"}
      else {message = "The first step is always the hardest, you got this!."}
      this.popover = new Popover(this.element, {
      content: message,
      trigger: "click", // Show popover on click
      placement: "right"
    });
  }
}
