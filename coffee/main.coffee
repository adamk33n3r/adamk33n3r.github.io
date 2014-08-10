titleize = (str) ->
  return str.replace /\w\S*/g, (txt) ->
    return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

# Adapted from http://www.noamdesign.com/how-to-make-all-anchor-links-scroll-instead-of-jump/
handle_anchors = ->
  # catch all clicks on a tags
  $("a").click ->
    # check if it has a hash (i.e. if it's an anchor link)
    console.log("ouch", this.hash)
    if (this.hash)
      hash = this.hash.substr(1)
      $toElement = $("[id=#{hash}]")
      toPosition = $toElement.position().top
      # scroll to element
      console.log "sdfkljasdfsdjafkljs", toPosition
      $("#container").animate
        scrollTop: toPosition
        2000
        "easeOutBounce"
    return false
  # do the same with urls with hash too (so on page load it will slide nicely)
  if (location.hash)
    hash = location.hash
    window.scroll 0, 0
    $("a[href=#{hash}]").click()

scrollTo = (section, pushState) ->
  toY = section.offsetTop
  $("#container").animate
    scrollTop: toY
    2000
    "easeOutBounce"
  if (pushState)
    history.pushState {section: section.id}, titleize(section.id), section.id

handle_anchors2 = ->
  if (location.pathname.length > 1)
    $section = $("[id=#{location.pathname.substring(1)}]")
    if ($section.length > 0)
      scrollTo $section[0]
  $("a").click ->
    section = this.getAttribute("href")
    $section = $("[id=#{section}]")
    if ($section.length > 0)
      scrollTo $section[0], true
    return false
  # When they push back
  $(window).on "popstate", ->
    if (location.pathname.length > 1)
      $section = $("[id=#{location.pathname.substring(1)}]")
      if ($section.length > 0)
        scrollTo $section[0], false
    else
      $("#container").animate
        scrollTop: 0
        2000
        "easeOutBounce"

$ ->
  history.replaceState({section: "splash-container"}, "splash", "")
  console.log(titleize("hello friend"))
  $(document.body).mousewheel (e) ->
    $container = $("#container")
    current_scroll = $container.scrollTop()
    $container.scrollTop current_scroll + (50 / -e.deltaY)
    current_scroll = $container.scrollTop()
    # Assuming we get them in the order they are on the page
    farthest = ""
    $(".row").each ->
      if (current_scroll >= this.offsetTop - 100)
        farthest = this
      console.log current_scroll, this.offsetTop, this.id, farthest.id
    if (history.state.section != farthest.id)
      if (farthest.id == $(".row")[0].id)
        history.pushState {section: farthest.id}, "", "/"
      else
        history.pushState {section: farthest.id}, titleize(farthest.id), farthest.id
      console.log("You made it to #{farthest.id}!")
#    console.log e.deltaX, e.deltaY, e.deltaFactor, $container.scrollTop(), $container.scrollTop() + (50 / -e.deltaY)
  handle_anchors2()