window.webcam =
  play: ->
    if navigator.getUserMedia
      navigator.getUserMedia
        webcam: true
        toString: ->
          "webcam"
      , @onSuccess, @onError
    else
      alert "getUserMedia is not supported in this browser.", true

  onSuccess: (stream) ->
    source = undefined
    source = window.webkitURL.createObjectURL(stream)
    webcam.autoplay = true
    webcam.src = source

  onError: ->
    alert "Please accept the getUserMedia permissions! Refresh to try again."

  setupPhotoBooth: ->
    snap = $("#snap")
    snap.click takePhoto
    saveButton = $("#save")
    saveButton.disabled = true
    saveButton.click savePhoto

  takePhoto: ->
    photo.width = webcam.width
    photo.height = webcam.height
    context = photo.getContext("2d")
    context.drawImage webcam, 0, 0, photo.width, photo.height
    saveButton = document.getElementById("save")
    saveButton.disabled = false

  savePhoto: ->
    data = photo.toDataURL("image/png")
    data = data.replace("image/png", "image/octet-stream")
    document.location.href = data

  initialize: ->
    webcam = $("#webcam").get([0])
    photo = $("#photo").get([0])
    webcam.width = 470
    webcam.height = 353
    conPhoto = $(photo)
    conVideo = $(webcam)
    conPhoto.prependTo $("#primary-container")
    conVideo.prependTo $("#primary-container")
    navigator.getUserMedia or (navigator.getUserMedia = navigator.mozGetUserMedia or navigator.webkitGetUserMedia or navigator.msGetUserMedia)
    @play()
    setupPhotoBooth()
