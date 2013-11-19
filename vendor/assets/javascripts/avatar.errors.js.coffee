# Add error class to avatar container if image fails to load
initAvatarImages = ->
  $('.avatar').imagesLoaded()
    .fail( (imgs) ->
      for img in imgs.images
        $(img.img).closest('.avatar').addClass('error') if img.isConfirmed and not img.isLoaded
    )

$(document).on 'ready page:load', ->
  initAvatarImages()
