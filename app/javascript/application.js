// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "chartkick/chart.js"
//// swiper core styles

// import 'swiper/swiper.min.css'
import "bootstrap"

// // modules styles
// import 'swiper/components/navigation/navigation.min.css'
// import 'swiper/components/pagination/pagination.min.css'
// @import 'swiper/scss';
// @import 'swiper/scss/pagination';
// @import 'swiper/scss/navigation';
document.addEventListener('DOMContentLoaded', function() {
  var popoverTrigger = new bootstrap.Popover(document.getElementById('popoverButton'));
});
