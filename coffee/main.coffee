$ ->
  $(document.body).mousewheel (e) ->
    $container = $("#container")
    $container.scrollTop $container.scrollTop() + (50 / -e.deltaY)
    console.log e.deltaX, e.deltaY, e.deltaFactor, $container.scrollTop(), $container.scrollTop() + (50 / -e.deltaY)
  $("a").each (idx, link) ->
    $(link).click ->
      console.log(link.href)
#      $("html").load(link.href)
      return false