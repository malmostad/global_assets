jQuery ($) ->
  # Delay click events so GA has time to collect data before executed
  window.gaDelayEvent = ($a, event) ->
    if !event.isDefaultPrevented() and !$a.attr('target') and !$a.attr('onclick')
      event.preventDefault()
      setTimeout('document.location = "' + $a.attr('href') + '"', 100)

  # Track outgoing links as regular page views
  $("a[href^='http://'], a[href^='https://']").click (event) ->
    $a = $(@)
    # Don't hijack href's in search results and URL's to malmo.se apps
    if $a.parents('.search-and-results').length is 0 and !$a.attr('href').match(/.malmo\.se\//)
      ga('send', {
        'hitType': 'pageview',
        'page': 'ExternalLink ' + $a.attr("href")
      })
      gaDelayEvent($a, event)

  # Track file downloads
  fileTypes = ['doc', 'docx', 'xls','xlsx', 'ppt', 'pptx', 'pdf', 'zip']
  $('a').each () ->
    $a = $(@)
    href = $a.attr('href')
    if typeof href is "string"
      href = href.split('.').pop()
      extension  = href.split('#').shift() # pdf files has an # in the search results

      if $.inArray(extension, fileTypes) isnt -1
        $a.click (event) ->
          link = $(this).attr("href")
          ga('send', {
            'hitType': 'pageview',
            'page': 'FileDownload ' + link
          })
          gaDelayEvent($a, event)
