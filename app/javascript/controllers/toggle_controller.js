import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ['mini','stand','super']
  connect() {
    console.log("hello")
  }

  show_mini() {
    if (this.miniTarget.classList.contains('d-none')){
      this.miniTarget.classList.remove('d-none');
      this.standTarget.classList.add('d-none');
      this.superTarget.classList.add('d-none');
      return
    } else {
      return this.miniTarget.classList.add('d-none');
    }
  }

  show_stand() {
    if (this.standTarget.classList.contains('d-none')){
      this.standTarget.classList.remove('d-none');
      this.miniTarget.classList.add('d-none');
      this.superTarget.classList.add('d-none');
      return
    } else {
      return this.standTarget.classList.add('d-none');
    }
  }

  show_super() {
    if (this.superTarget.classList.contains('d-none')){
      this.superTarget.classList.remove('d-none');
      this.miniTarget.classList.add('d-none');
      this.standTarget.classList.add('d-none');
      return
    } else {
      return this.superTarget.classList.add('d-none');
    }
  }

}
