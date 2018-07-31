function copyLink() {
	var copyText = document.getElementById("order-link");
	copyText.select();
	document.execCommand("copy");
}