#= require jquery
#= require webcam
#= require_self

$ ->
  webcamAPI.initialize()

  # Having two methods for adding photos is dumb. We are looping through the
  # current set of photos and outputting them with a specific markup while 
  # having to maintain this same markup when snapping a photo. Let's fix 
  # this at some point.

  for photo in webcamAPI.getPhotos()
    container = $('<div class="photo-container"></div>')
    foto = $('<img />').attr('src', photo.data).appendTo('#past-photos')

    container.appendTo('#past-photos')
    foto.appendTo(container)

    $('<div class="delete-photo"></div>').appendTo(container)
    $('<input type="hidden"></input>').val(photo.data).prependTo('form')

  $('.delete-photo').click ->
    container = $(this).parent('.photo-container')
    container.remove()
    # Need to actually delete the photo from local storage too.