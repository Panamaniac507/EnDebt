// stimulus/controllers/swiper_controller.js
import { Controller } from "@hotwired/stimulus";
import Swiper from "swiper/bundle";

// export default class extends Controller {
//   static targets = ["swiper-container"];
//   swiper = null;

//   connect() {
//     console.log("yey")
//     this.swiper = new Swiper(this.swiperContainerTarget, {
//       // Swiper options and configuration here
//       direction: "horizontal",
//       loop: true,
//       navigation:
//       {nextEl: '.swiper-button-next',
//       prevEl: '.swiper-button-prev'}
//       // Additional options...
//     });
//     console.log("check")
//   }

//   prevSlide() {
//     this.swiper.slidePrev();
//   }

//   nextSlide() {
//     this.swiper.slideNext();
//   }
// }
export default class extends Controller {
  connect() {
    new Swiper(".mySwiper", {
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev",
      },
    });
  }
}



// export default class extends Controller {
//   connect() {
//     new Swiper(this.element, {
//       navigation: {
//         nextEl: this.nextButtonTarget,
//         prevEl: this.prevButtonTarget,
//       },
//     });
//     console.log(this.element)
//     console.log(this.nextButtonTarget)
//   }

//   get nextButtonTarget() {
//     console.log("check1");
//     console.log(this.data.get("nextButtonTarget"));
//     return this.data.get("nextButtonTarget");
//   }

//   get prevButtonTarget() {
//     return this.data.get("prevButtonTarget");
//   }
// }
