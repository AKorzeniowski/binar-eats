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

for (let step of steps) { step.style.display = 'none' }

var currentStep = 0
steps[currentStep].style.display = 'block'

const nextButtons = document.getElementsByClassName('wizard__button--next')
for (let button of nextButtons) {
	button.onclick = (event) => {
		event.preventDefault()
		steps[currentStep].style.display = 'none'
		currentStep++
		steps[currentStep].style.display = 'block'
	}
}