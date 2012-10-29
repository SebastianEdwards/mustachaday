#= require jquery
#= require webcam
#= require_self

$ ->
  webcamAPI.initialize()
  $('.photo-container').hover webcamAPI.displayOptions, webcamAPI.hideOptions