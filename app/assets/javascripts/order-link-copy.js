$(document).on('turbolinks:load', function() {
	let copyTextButton = document.getElementById("copy-link-button")

	copyTextButton.onclick = function(event) {
		linkTextfield = document.getElementById("copy-link-textarea")
		linkTextfield.select()
		document.execCommand("copy")
	}
})