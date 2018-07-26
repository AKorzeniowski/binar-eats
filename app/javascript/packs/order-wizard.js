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

var currentStep = 0
steps[currentStep].style.display = 'block'

const nextButtons = Array.from(document.getElementsByClassName('nextStep'))
nextButtons.forEach((button) => button.onclick = () => { 
	steps[currentStep].style.display = 'none'; 
	currentStep++; 
	steps[currentStep].style.display = 'block';
 })