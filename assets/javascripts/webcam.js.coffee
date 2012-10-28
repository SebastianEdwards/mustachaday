window.webcamAPI =
  play: ->
    if navigator.getUserMedia
      navigator.getUserMedia
        video: true
      , @onSuccess, @onError
    else
      alert "getUserMedia is not supported in this browser.", true

  onSuccess: (stream) ->
    $('#snap').removeAttr 'disabled'
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
    photos = @getPhotos()
    photos.push
      data: data
    @setPhotos(photos)

  rollOutPhoto: ->
    photos = @getPhotos()
    lastPhoto = photos.slice(-1)[0]
    @addPhoto lastPhoto, photos.length - 1, true

  setPhotos: (photos) ->
    localStorage.images = JSON.stringify(photos)

  getPhotos: ->
    if localStorage.images
      store = JSON.parse(localStorage.images)
    else
      store = []

  addPhoto: (photo, id, animate=false) ->
    $container = $('<div class="photo-container"></div>').prependTo('#past-photos')
    $('<img />').attr('src', photo.data).appendTo($container)
    $('<div class="delete-photo"></div>').appendTo($container).click =>
      $container.remove()
      $("form input[data-id=#{id}]").remove()
      @deletePhoto id
    blob = photo.data.replace(/data:image\/jpeg;base64,/, '')
    $('<input name="images[]" type="hidden"></input>').attr('data-id', id).val(blob).prependTo('form')

  addPhotos: ->
    for photo, i in @getPhotos()
      do (photo) => @addPhoto photo, i

  deletePhoto: (id) ->
    photos = @getPhotos()
    delete photos[id]
    photos = $.map photos, (p) -> p
    @setPhotos(photos)

  initialize: ->
    @addPhotos()
    webcam.width = 470
    webcam.height = 353
    navigator.getUserMedia or= (navigator.mozGetUserMedia or navigator.webkitGetUserMedia or navigator.msGetUserMedia)
    @play()
    @setupPhotoBooth()
