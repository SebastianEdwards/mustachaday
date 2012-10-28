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
    if photo.data != ""
      container = $('<div class="photo-container"></div>')
      foto = $('<img />').attr('src', photo.data).appendTo('#past-photos')

      container.appendTo('#past-photos')
      foto.appendTo(container)

      $('<div class="delete-photo"></div>').appendTo(container)
      $('<input type="hidden"></input>').val(photo.data).prependTo('form')

  $('.delete-photo').click ->
    dataId = $(this).parent('.photo-container').attr('data-id')
    console.log dataId
    thisPhotoData = container.find('img').attr('src')
    
    # I'm doing this in a dumb way but hey there is a deadline to meet here!
    # When deleting a photo it leaves the remains of the data key. Not quite
    # sure how to remove it so instead I've quickly placed a conditional
    # for the getPhotos function.

    container.remove()
