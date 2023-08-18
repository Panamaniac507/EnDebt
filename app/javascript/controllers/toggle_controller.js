import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ['mini']
  connect() {
    console.log("hello")
  }

  show_mini() {
    this.miniTarget.classList.remove('d-none');
  }

  show_standard() {

  }

  show_super() {

  }

}
