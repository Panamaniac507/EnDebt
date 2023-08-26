import { Controller } from "@hotwired/stimulus"
import "particles.js"
// Connects to data-controller="confetti"
export default class extends Controller {
  connect() {
    console.log("confetti")
    this.celebrate()
  }


    // console.log(queryString);
    // const urlParams = new URLSearchParams(queryString);
    // console.log(urlParams)
    // const payment = urlParams.get('payment')

    // if (payment) {
    //   this.celebrate()
    // }
  celebrate() {
    // event.preventDefault()
    console.log("celebrate")
    particlesJS.load('particles-js', "/pconfig.json", () => {
    setTimeout(() => {
      this.element.innerHTML = ""
    }, 10000);
      console.log('callback - particles-js config loaded');
    });
  }
}
