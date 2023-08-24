import { Controller } from "@hotwired/stimulus"
import "particles.js"
// Connects to data-controller="confetti"
export default class extends Controller {
  connect() {
    console.log("confetti")
    // this.particles = new particlesJS()
  }
  celebrate(event) {
    event.preventDefault()
    console.log("celebrate")
    particlesJS.load('particles-js', "pconfig.json", function() {
    setTimeout(() => {
      document.querySelector("#particles-js").remove()
    }, 3000);
      console.log('callback - particles-js config loaded');
    });
  }
}
