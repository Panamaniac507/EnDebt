// stimulus/controllers/swiper_controller.js
import { Controller } from "@hotwired/stimulus";
import Swiper from "https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.mjs";

export default class extends Controller {
  static targets = ["container"];
  swiper = null;

  connect() {
    console.log("yey")
    this.swiper = new Swiper(this.containerTarget, {
      // Swiper options and configuration here
      loop: true,
      // Additional options...
    });
  }

  prevSlide() {
    this.swiper.slidePrev();
  }

  nextSlide() {
    this.swiper.slideNext();
  }
}
