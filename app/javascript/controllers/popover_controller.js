import { Controller } from "@hotwired/stimulus"
import { Popover } from "bootstrap";
// Connects to data-controller="popover"
export default class extends Controller {
  connect() {
    this.popover = new Popover(this.element, {
      content: "This is a popover content.",
      trigger: "click", // Show popover on click
      placement: "left"
    });
  }
}
