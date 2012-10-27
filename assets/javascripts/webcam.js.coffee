window.webcamAPI =
  play: ->
    if navigator.getUserMedia
      navigator.getUserMedia
        video: true
      , @onSuccess, @onError
    else
      alert "getUserMedia is not supported in this browser.", true

  onSuccess: (stream) ->
    source = window.webkitURL.createObjectURL(stream)
    webcam.autoplay = true
    webcam.src = source

  onError: ->
    alert "Please accept the getUserMedia permissions! Refresh to try again."

  setupPhotoBooth: ->
    snap = $("#snap")
    snap.click @takePhoto
    saveButton = $("#save")
    saveButton.disabled = true
    saveButton.click @savePhoto

  takePhoto: ->
    photo.width = webcam.width
    photo.height = webcam.height
    context = photo.getContext("2d")
    context.drawImage webcam, 0, 0, photo.width, photo.height
    saveButton = document.getElementById("save")
    saveButton.disabled = false

  savePhoto: ->
    data = photo.toDataURL("image/jpeg")
    if localStorage.images
      store = JSON.parse(localStorage.images)
    else
      store = []
    store.push
      data: data
    localStorage.images = JSON.stringify(store)

  getPhotos: ->
    if localStorage.images
      store = JSON.parse(localStorage.images)
    else
      store = []

  initialize: ->
    webcam.width = 470
    webcam.height = 353
    navigator.getUserMedia or= (navigator.mozGetUserMedia or navigator.webkitGetUserMedia or navigator.msGetUserMedia)
    @play()
    @setupPhotoBooth()
