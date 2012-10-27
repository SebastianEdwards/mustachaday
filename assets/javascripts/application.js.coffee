#= require jquery
#= require webcam
#= require_self

$ ->
  webcamAPI.initialize()

  for photo in webcamAPI.getPhotos()
    $('<img />').attr('src', photo.data).appendTo('#past-photos')
