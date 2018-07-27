/* eslint no-console: 0 */
const steps = document.getElementsByClassName('wizard__step')

for (let step of steps) { hide(step) }

var currentStep = 0
show(steps[currentStep])

const nextButtons = document.getElementsByClassName('wizard__button--next')
for (let button of nextButtons) {
	button.onclick = (event) => {
		event.preventDefault()
		hide(steps[currentStep])
		currentStep++
		show(steps[currentStep])
	}
}

function show(element) {
	element.style.display = 'block'
}

function hide(element) {
	element.style.display = 'none'
}