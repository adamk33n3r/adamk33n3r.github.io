---
---

TYPES = "default monokai solarized solarized256"

titleize = (str) ->
  return str.replace /\w\S*/g, (txt) ->
    return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

scrollToTop = ->
  animate_scroll_to 0
  if location.hash.length > 0
    history.pushState {section: "splash-container"}, "splash", "/"
  slide $("#back_to_top"), {right: -100}

animate_scroll_to = (toY) ->
  $body.animate
    scrollTop: toY
    1000
    "easeOutExpo"

scrollTo = (section, pushState) ->
  animate_scroll_to section.offsetTop
  $("#back_to_top").fadeIn()
  if pushState
    history.pushState {section: section.id}, titleize(section.id), "##{section.id}"

handle_anchors2 = ->
  if location.hash.length > 1
    section = $(location.hash)[0]
    if section
      scrollTo section, true
      slide $("#back_to_top"), {right: 25}
  else
    history.replaceState({section: "splash-container"}, "splash", "")
  $("a").click ->
    section = @getAttribute("href")
    if not section.startsWith '#'
      return true
    $section = $("[id=#{section.substring(1)}]")
    if $section.length > 0
      scrollTo $section[0], true
      slide $("#back_to_top"), {right: 25}
    return false
  # When they push back/forward
  $(window).on "popstate", ->
    if location.hash.length > 0
      $section = $(location.hash)
      if $section.length > 0
        scrollTo $section[0], false
        slide $("#back_to_top"), {right: 25}
    else
      scrollToTop()
  $(window).on "hashchange", ->
    if location.hash.length > 0
      $section = $(location.hash)
      if $section.length > 0
        scrollTo $section[0], false
        slide $("#back_to_top"), {right: 25}
      else
        scrollToTop()
    else
      scrollToTop()

get_current_section = ->
  current_scroll = $body.scrollTop()
  farthest = ""
  $(".row").each ->
    if current_scroll >= this.offsetTop - 100
      farthest = this
#    console.log current_scroll, this.offsetTop, this.id, farthest.id
  return farthest

get_section_after = (section) ->
  return $("##{section}").next ".row"

get_section_before = (section) ->
  return $("##{section}").prev ".row"

goToNextSection = ->
  next_section = get_section_after(history.state.section)[0]
  if next_section
    animate_scroll_to next_section.offsetTop
    history.pushState {section: next_section.id}, titleize(next_section.id), "##{next_section.id}"
    slide $("#back_to_top"), {right: 25}

goToPrevSection = ->
  prev_section = get_section_before(history.state.section)[0]
  if prev_section
    animate_scroll_to prev_section.offsetTop
    if prev_section.id == $(".row")[0].id
#      history.pushState {section: prev_section.id}, "splash", "/"
      scrollToTop()
    else
      history.pushState {section: prev_section.id}, titleize(prev_section.id), "##{prev_section.id}"
      slide $("#back_to_top"), {right: 25}

check_scrolling = ->
  # Assuming we get them in the order they are on the page
  current_section = get_current_section()
  if not history.state? and current_section.id isnt 'splash-container'
    history.pushState {section: current_section.id}, titleize(current_section.id), "##{current_section.id}"
    slide $("#back_to_top"), {right: 25}
  else
    if history.state.section != current_section.id
      if current_section.id == $(".row")[0].id
        history.pushState {section: current_section.id}, "splash", "/"
        slide $("#back_to_top"), {right: -50}
  #      scrollToTop()
      else
        history.pushState {section: current_section.id}, titleize(current_section.id), "##{current_section.id}"
        slide $("#back_to_top"), {right: 25}
#      console.log("You made it to #{farthest.id}!")

slide = (ele, to, options) ->
  $(ele).animate to, options

show_secrets = ->
  $("#name, #navbar").hide()
  $("#secrets").fadeIn()


handleCodeStyler = ->
  _add_wrapper($(".highlighttable, .highlight:not(td .highlight)"))
  $select = $(".code-box-header > select")
  $select.val(window.localStorage.getItem("style") or "default")
  $select.change (e) ->
    $select.val(this.value)
    $select.parent().parent().attr("class", "code-box #{this.value}")
    window.localStorage.setItem("style", this.value)
  $select.change()
  $highlights = $(".highlight:not(td .highlight)")
  $highlights.each (idx, ele) ->
    $linenos = $(ele).find(".lineno")
    $linenos.first().addClass("first")
    $linenos.last().addClass("last")


upper = (str) ->
  str.charAt(0).toUpperCase() + str.slice(1)


_add_wrapper = (code_blocks) ->
  for block in code_blocks
    $block = $(block)
    $box = $("<div>").addClass("code-box default")
    lang = $block.find("code").data("lang")
    header = "<div class=\"code-box-header\">#{upper(lang)}<select>"
    for style in TYPES.split(' ')
      header += "<option value=\"#{style}\">#{upper(style)}</option>"
    header += "</select></div>"
    $header = $(header)
    new_content = $box.append($header).append($block.clone())
    $block.replaceWith(new_content)

CAN_SCROLL = true
SCROLL_DELTA_FACTOR = 1
$body = null
$ ->
  $body = $(document.body)

  SCROLL_DELTA_FACTOR = switch $.client.os
    when "Windows", "Linux" then 50
    when "Mac" then 1
  if location.hash
    setTimeout ->
      $("#container").scrollTop(0)
      handle_anchors2()
    , 1
  else
      handle_anchors2()
  console.log('Hello, friend')
  $body.keydown (e) ->
    switch e.which
      when 13
        goToNextSection()
      when 220
        goToPrevSection()
      when 38
        $body.scrollTop($body.scrollTop() - 50)
        check_scrolling()
        console.log 38
      when 40
        $body.scrollTop($body.scrollTop() + 50)
        check_scrolling()
      when 72
        console.log 'home'
        animate_scroll_to 0
        history.pushState {section: get_current_section().id}, "", "/"
  $body.mousewheel (e) ->
    if CAN_SCROLL
      current_scroll = $body.scrollTop()
      check_scrolling()
    else
      e.preventDefault()

  $("#back_to_top").click ->
    scrollToTop()

  handleCodeStyler()

  $("#name").click ->
    CAN_SCROLL = false
    console.log "Clicked on my name!"
    $("#navbar").css("position", "relative")
    slide $("#navbar"), top: 1000,
      duration: 1000
    $(this).css("position", "relative")
    slide this, top: -1000,
      done: show_secrets
      duration: 1000
  $("#secrets").click ->
    console.log "Going back!"
    $(this).fadeOut()
    $("#name, #navbar").show()
    slide $("#name, #navbar"), top: 0,
      done: ->
        CAN_SCROLL = true
      duration: 1000

