/* eslint no-console: 0 */
// import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue/dist/vue.esm'
// import OrderWizard from '../order-wizard.vue.erb'

// Vue.use(TurbolinksAdapter)

// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     el: '#wizard',
//     components: { 
//     	'order-wizard': OrderWizard,
//     }
//   })
// })
let placeStep = document.getElementById("place")
let ordererStep = document.getElementById("orderer")
let delivererStep = document.getElementById("deliverer")
let deadlineStep = document.getElementById("deadline")

let steps = [placeStep, ordererStep, delivererStep, deadlineStep]

steps.forEach((item) => item.style.display = 'none')