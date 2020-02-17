# Intranet specific GA logging
jQuery ($) ->
  # Track department/working field from cookie as Event logging
  profile = $.cookie(msettings.myprofileName) or {}
  ga('send', 'event', 'HRDepartment', profile.hr_department or 'none')
  ga('send', 'event', 'Department', profile.department or 'none')
  ga('send', 'event', 'WorkingField', profile.workingfield or 'none')

  # Tracking of categories and author for "Nyheter" and "Blogg". `newsTracking` and `blogTracking` is defined on those sites
  if typeof newsTracking isnt 'undefined'
    $.each newsTracking['categories'], (index, category) ->
      ga('send', 'event', 'newsCategory',   "newsCategory-" + category)
    ga('send', 'event', 'newsAuthor', "newsAuthor-" + newsTracking['author'])

  if typeof blogTracking isnt 'undefined'
    $.each blogTracking['categories'], (index, category) ->
      ga('send', 'event', 'blogCategory', "blogCategory-" + category)
    ga('send', 'event', 'blogAuthor', "blogAuthor-" + blogTracking['author'])

  # GA event tracking of top menu selection
  $("#malmo-masthead .nav-logo a, #malmo-masthead nav li[class!='dropdown'] a, #malmo-masthead nav li.dropdown ul a").click (event) ->
    $a = $(@);

    # Special case for department & workingfield dropdowns
    if $a.parents("#nav-my-department").length then text = "Förvaltningar"
    else if $a.parents("#nav-my-workingfield").length then text = "Mitt arbetsfält"
    else if $a.parents("#masthead-others").length then text = $a.attr("title")
    else text = $a.text()

    ga('send', 'event', 'topMenuClick', text, $a.attr('href').replace(/https*:\/\/.*\//, '/'))
    gaDelayEvent($a, event)
