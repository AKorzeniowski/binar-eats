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

  function checkInputs() {
    if ($("input[name='own_place_name']").val().length != 0 && $("input[name='own_place_menu_url']").val().length != 0) {
      $('.wizard__button--next').attr("disabled", false)
    } else {
      $('.wizard__button--next').attr("disabled", true)
    }
  }

  function addInputs() {
    $('#own_place').append("<tr><td>Name</td><td><input name='own_place_name' placeholder='Order place name...' required></td></tr>")
    $('#own_place').append("<tr><td>Address</td><td><input name='own_place_address' placeholder='Order place address...'></td></tr>")
    $('#own_place').append("<tr><td>Menu[url]</td><td><input name='own_place_menu_url' placeholder='Order place menu url...' required></td></tr>")
  }

  $('#order_place_id').change(function() {
    $('#own_place').empty()
    $('.wizard__button--next').attr("disabled", true)
    if ($(this).val() == 5) {
      addInputs();
      $("input[name='own_place_name']").change(function() {
        checkInputs()
      })
      $("input[name='own_place_menu_url']").change(function() {
        checkInputs()
      })
    } else {
      $('.wizard__button--next').attr("disabled", false)
    }
  })
});
