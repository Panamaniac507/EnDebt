import { Controller } from "@hotwired/stimulus"
import { Popover } from "bootstrap";
// Connects to data-controller="popover"
export default class extends Controller {
  connect() {
    this.popover = new Popover(this.element, {
      content: "The first step is always the hardest, you got this!.",
      trigger: "click", // Show popover on click
      placement: "right"
    });
  }
}
