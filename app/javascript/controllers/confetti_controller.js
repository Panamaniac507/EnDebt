import { Controller } from "@hotwired/stimulus"
import "particles.js"
// Connects to data-controller="confetti"
export default class extends Controller {
  connect() {
    console.log("confetti")
    // this.particles = new particlesJS()
    const queryString = window.location.search;
    console.log(queryString);
    const urlParams = new URLSearchParams(queryString);
    const payment = urlParams.get('payment')

    if (payment) {
      this.celebrate()
    }
  }
  celebrate(event) {
    // event.preventDefault()
    console.log("celebrate")
    particlesJS.load('particles-js', "pconfig.json", function() {
    setTimeout(() => {
      this.element.remove()
    }, 3000);
      console.log('callback - particles-js config loaded');
    });
  }
}
