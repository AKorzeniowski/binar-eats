$(document).on('turbolinks:load', function() {
  const steps = document.getElementsByClassName('wizard__step')


  for (let step of steps) {
    hide(step)
  }

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

  if ($('#order_place_id').children('option').length < 5) {
    $('#order_place_id').append('<option value="5">Another place</option>')
  }

  $('#order_place_id').change(function() {
    $('#own_place').empty()
    if ($(this).val() == 5) {
      $('#own_place').append("Place name <input name='own_place_name' placeholder='Enter your order place name...' required> </br>")
			$('#own_place').append("Place menu url <input name='own_place_menu_url' placeholder='Enter your order place menu url...' required>")
    }
  })

});
