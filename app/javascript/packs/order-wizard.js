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
const placeStep = document.getElementById("place")
const ordererStep = document.getElementById("orderer")
const delivererStep = document.getElementById("deliverer")
const deadlineStep = document.getElementById("deadline")

const steps = [placeStep, ordererStep, delivererStep, deadlineStep]

steps.forEach((item) => item.style.display = 'none')

steps[0].style.display = 'block'