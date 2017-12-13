# Integrations for SBK's map service
jQuery ($) ->
  if $("body.test, body.development").length then mapEnv = "test" else mapEnv = "prod"

  # Used for iframe with single POI
  urlForInlineMap = (streetAddress) ->
    encodeURI "//kartor.malmo.se/init/?appid=adresskarta-v1&poi=#{streetAddress}"

  # Used for full map with single POI
  urlForFullMap = (streetAddress) ->
    encodeURI "https://malmo.se/karta?poi=#{streetAddress}&zoomlevel=4&maptype=karta"

  # Rewrite href attr on load to enable right click open in full map
  $("[data-poi]").attr "href", ->
    urlForFullMap($(@).attr("data-poi"))

  # Replace `data-map-selector` contents with the iframe and set the src from `data-poi`
  $("body").on "click", "[data-poi]", (event) ->
    event.preventDefault()
    $selector = $($(@).attr("data-map-selector"))

    if $selector.length
      # Create a map if not present
      if $selector.find("iframe").length < 1
        $iframe = $('<iframe scrolling="no" frameborder="0" src=""></iframe>')

        $(@).attr('data-text', $(@).text())
        $(@).text("dölj karta")

        # Inject the iframe
        $selector.show().html($iframe.attr("src", urlForInlineMap($(@).attr("data-poi"))))

        # After injection, scroll to the top of `data-scroll-to` or the $selector
        if $(@).is("[data-scroll-to]")
          $('html, body').animate
            scrollTop: $($(@).attr("data-scroll-to")).offset().top - 45
          , 100

      # Map is present, remove it
      else
        $(@).text($(@).attr('data-text'))
        $selector.empty().hide()

  # Show theme map
  $(".theme-map button").click ->
    $(@).blur()
    $box = $(@).parent()

    # Create a map if not present
    if $box.find("iframe").length < 1
      $(@).attr('data-text', $(@).text())
      $(@).text("Dölj karta")
      $box.append $("<div class='map-box'><iframe scrolling='no' frameborder='0' src='#{$(@).attr("data-url")}'></iframe></div>")

      # After injection, scroll to the top of the $box
      $('html, body').animate
        scrollTop: $(@).offset().top - 60
      , 100

    # Map is present, remove it
    else
      $(@).text($(@).attr('data-text'))
      $box.find(".map-box").remove()
