jQuery ($) ->
  # Inject the masthead from the stringified html code
  $(malmoMasthead).prependTo('body')

  $malmoMastheadNav = $("#malmo-masthead nav.masthead-main")

  isNarrow = ->
    $("#nav-search-trigger").is(":visible")

  hideNav = ->
    $("body").removeClass("nav-open")
    $malmoMastheadNav.removeClass("expanded")
    $(document).off 'click.nav'

  showNav = (event) ->
    hideSearch()
    $("body").addClass("nav-open")
    $malmoMastheadNav.addClass("expanded")
    # Close on click outside the list
    $(document).on 'click.nav', (event) ->
      if $(event.target).is("ul")
        hideNav()

  # We use the cookie values to change two nav items
  hijackNav = (navItem, items, plural) ->
    # Add a dropdown if the user has more than one items
    if items.length > 1
      $(navItem).addClass('dropdown')
        .find('a')
        .addClass('dropdown-toggle no-arrow')
        .attr('data-toggle', 'dropdown')
        .text(plural)
        .append('<span class="icon-caret-down">')
        .end()
        .append('<ul class="dropdown-menu"></ul>')

      $.each items, (index, value) ->
        $(navItem).find('ul').append('<li><a href="' + value.homepage_url + '">' + value.name + '</a></li>')

    # Change the href if the user has one item
    else if items.length is 1
      $(navItem).find('a').attr('href', items[0].homepage_url)

  # Users profile from the Dashboard is available in a cookie.
  $.cookie.json = true

  profile = $.cookie(msettings.myprofileName) || {}
  if profile.departments then hijackNav('#nav-my-department', profile.departments, 'Mina förvaltningar')
  if profile.workingfields then hijackNav('#nav-my-workingfield', profile.workingfields, 'Mina arbetsfält')

  $("#nav-menu-trigger a").click (event) ->
    event.preventDefault()
    if $("#malmo-masthead nav.masthead-main").is(":hidden") then showNav(event) else hideNav()

  # Browser sniffing hack for landscape text size on iPhone. Note: Prevents zooming on desktops so we limit it to iOS.
  if /iPhone|iPod/.test(navigator.platform) and navigator.userAgent.indexOf("AppleWebKit") > -1
    $("html").attr("style", "-webkit-text-size-adjust: none")

  # https://github.com/ftlabs/fastclick
  new FastClick $('#nav-menu-trigger')[0]

  # Turn off Bootstraps hover look-alikes on touch devices
  $(document).off('touchstart.dropdown')

# Search form
  $mastheadSearch = $("#masthead-search")
  hideSearch = ->
    $mastheadSearch.removeClass("expanded")
    $("#masthead-q-komin").addClass("input-sm").blur()
    $mastheadSearch.find("div").removeClass("input-append input-prepend")
    $(document).off 'click.searchForm'

  showSearch = ->
    hideNav() if isNarrow()

    $mastheadSearch.addClass("expanded")
    $("#masthead-q-komin").removeClass("input-sm")
    $mastheadSearch.find("div").addClass("input-append input-prepend")

    # Close on click outside the searchbox
    $(document).one 'mousedown', (event) ->
        hideSearch() unless $(event.target).closest("#masthead-search, #nav-search-trigger").length

  # Bind escape key to hide form
  $mastheadSearch.focusin ->
    $(document).on 'keyup.searchForm', (event) ->
      hideSearch() if event.which is 27

  # Un-bind escape key
  $mastheadSearch.focusout ->
    $(document).off('keyup.searchForm')

  $('#masthead-q-komin').focus ->
    showSearch()

  $mastheadSearch.find('.m-icon-search').click ->
    $('#masthead-q-komin').focus()

  $("#nav-search-trigger a").click (event) ->
    event.preventDefault()
    if $("#masthead-search-intranet input.q").is(":hidden") then showSearch() else hideSearch()
