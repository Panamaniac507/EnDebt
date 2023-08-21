import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ['mini','stand','super','debt','plans']
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

  page_change() {
    if (this.debtTarget.classList.contains('d-none')){
      this.debtTarget.classList.remove('d-none');
      if (this.plansTarget.classList.contains('d-none')){
        return
      } else {
        this.plansTarget.classList.add('d-none');
      }
      return
    } else {
      this.debtTarget.classList.add('d-none');
      if (this.plansTarget.classList.contains('d-none')){
        return this.plansTarget.classList.remove('d-none');
      }
    }
  }

}
