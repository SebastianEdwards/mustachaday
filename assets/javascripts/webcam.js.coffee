window.webcamAPI =
  play: ->
    if navigator.getUserMedia
      navigator.getUserMedia
        video: true
      , @onSuccess, @onError
    else
      alert "getUserMedia is not supported in this browser.", true

  onSuccess: (stream) ->
    $('.snap').removeAttr 'disabled'
    $('.gif').removeAttr 'disabled'
    $('.video-overlay').delay(1000).show(0)
    source = window.webkitURL.createObjectURL(stream)
    webcam.autoplay = true
    webcam.src = source

  onError: ->
    alert "Please accept the getUserMedia permissions! Refresh to try again."

  setupPhotoBooth: ->
    snap = $(".snap")
    snap.click =>
      @takePhoto()
      @savePhoto()
      @rollOutPhoto()

  takePhoto: ->
    @snapEffect()
    photo.width = webcam.width
    photo.height = webcam.height
    context = photo.getContext("2d")
    context.drawImage webcam, 0, 0, photo.width, photo.height

  snapEffect: ->
    $('.snap-overlay')
      .show()
      .animate({
        opacity: 0
        }, 1000, ->
          $(this)
            .hide()
            .css(opacity: 1)
          )

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
    # Will clean this up laters
    if animate
      $('.snap').attr('disabled', 'disabled')
      mainContainer = $('.past-photos-container').css(marginTop: '-513px')
      $container = $('<div class="photo-container"></div>').prependTo('.past-photos-container')
      $('<img class="photo" />').attr('src', photo.data).appendTo($container)

      $('<div class="delete-photo">&#10006;</div>').appendTo($container).click =>
        $container.remove()
        $("form input[data-id=#{id}]").remove()
        @deletePhoto id

      blob = photo.data.replace(/data:image\/jpeg;base64,/, '')
      $('<input name="images[]" type="hidden"></input>').attr('data-id', id).val(blob).appendTo('form')

      mainContainer.animate({marginTop: '0px'}, 4000, 'linear', ->
        $('.snap').removeAttr 'disabled'
        )
      
    else
      $container = $('<div class="photo-container"></div>').prependTo('.past-photos-container')
      $('<img class="photo" />').attr('src', photo.data).appendTo($container)
      $('<div class="delete-photo">&#10006;</div>').appendTo($container).click =>
        $container.remove()
        $("form input[data-id=#{id}]").remove()
        @deletePhoto id
      blob = photo.data.replace(/data:image\/jpeg;base64,/, '')
      $('<input name="images[]" type="hidden"></input>').attr('data-id', id).val(blob).appendTo('form')

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
