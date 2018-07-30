$(document).on('turbolinks:load', function() {
	const steps = document.getElementsByClassName('wizard__step')

	for (let step of steps) { hide(step) }

	var currentStep = 0
	show(steps[currentStep])

	const nextButtons = document.getElementsByClassName('wizard__button--next')

	for (let button of nextButtons) {
		button.onclick = (event) => { changeStep(event, 1) }
	}

	const prevButtons = document.getElementsByClassName('wizard__button--prev')
	for (let button of prevButtons) {
		button.onclick = (event) => { changeStep(event, -1) }
	}

	function changeStep(event, amount) {
		event.preventDefault()
		hide(steps[currentStep])
		currentStep = currentStep + amount
		show(steps[currentStep])
	}

	function show(element) {
		element.style.display = 'block'
	}

	function hide(element) {
		element.style.display = 'none'
	}
});