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
    snap.click =>
      @takePhoto()
      @savePhoto()
      @rollOutPhoto()

  takePhoto: ->
    photo.width = webcam.width
    photo.height = webcam.height
    context = photo.getContext("2d")
    context.drawImage webcam, 0, 0, photo.width, photo.height

  savePhoto: ->
    data = photo.toDataURL("image/jpeg")
    if localStorage.images
      store = JSON.parse(localStorage.images)
    else
      store = []
    store.unshift
      data: data
    localStorage.images = JSON.stringify(store)

  rollOutPhoto: ->
    photo = webcamAPI.getPhotos()[0]
    $container = $('<div class="photo-container"></div>').prependTo('#past-photos')
    $('<img />').attr('src', photo.data)
      .appendTo($container)
      .animate({
        marginTop: '0px'
        }, 3000, 'linear')
    $('<div class="delete-photo"></div>').appendTo($container).click ->
      console.log 'hi'
      $container.remove()
      # TODO: Need to actually delete the photo from local storage too.
    blob = photo.data.replace(/data:image\/jpeg;base64,/, '')
    $('<input name="images[]" type="hidden"></input>').val(blob).prependTo('form')

  getPhotos: ->
    if localStorage.images
      store = JSON.parse(localStorage.images)
    else
      store = []    

  # Having two methods for adding photos is dumb. We are looping through the
  # current set of photos and outputting them with a specific markup while 
  # having to maintain this same markup when snapping a photo. Let's fix 
  # this at some point.

  initialize: ->
    for photo in webcamAPI.getPhotos()
      do (photo) ->
        $container = $('<div class="photo-container"></div>').appendTo('#past-photos')
        $('<img />').attr('src', photo.data).appendTo($container)
        $('<div class="delete-photo"></div>').appendTo($container).click ->
          $container.remove()
          # TODO: Need to actually delete the photo from local storage too.
        blob = photo.data.replace(/data:image\/jpeg;base64,/, '')
        $('<input name="images[]" type="hidden"></input>').val(blob).prependTo('form')
    webcam.width = 470
    webcam.height = 353
    navigator.getUserMedia or= (navigator.mozGetUserMedia or navigator.webkitGetUserMedia or navigator.msGetUserMedia)
    @play()
    @setupPhotoBooth()
