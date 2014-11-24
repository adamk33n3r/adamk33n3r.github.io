// Generated by CoffeeScript 1.7.1
(function() {
  var CAN_SCROLL, SCROLL_DELTA_FACTOR, TYPES, animate_scroll_to, check_scrolling, get_current_section, get_section_after, get_section_before, goToNextSection, goToPrevSection, handleCodeStyler, handle_anchors, handle_anchors2, scrollTo, scrollToTop, show_secrets, slide, titleize, upper, _add_wrapper;

  TYPES = "default monokai solarized solarized256";

  titleize = function(str) {
    return str.replace(/\w\S*/g, function(txt) {
      return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    });
  };

  handle_anchors = function() {
    var hash;
    $("a").click(function() {
      var $toElement, hash, toPosition;
      console.log("ouch", this.hash);
      if (this.hash) {
        hash = this.hash.substr(1);
        $toElement = $("[id=" + hash + "]");
        toPosition = $toElement.position().top;
        console.log("sdfkljasdfsdjafkljs", toPosition);
        $("#container").animate({
          scrollTop: toPosition
        }, 2000, "easeOutBounce");
      }
      return false;
    });
    if (location.hash) {
      hash = location.hash;
      window.scroll(0, 0);
      return $("a[href=" + hash + "]").click();
    }
  };

  animate_scroll_to = function(toY) {
    return $("#container").animate({
      scrollTop: toY
    }, 1000, "easeOutExpo");
  };

  scrollTo = function(section, pushState) {
    animate_scroll_to(section.offsetTop);
    $("#back_to_top").fadeIn();
    if (pushState) {
      return history.pushState({
        section: section.id
      }, titleize(section.id), "#" + section.id);
    }
  };

  handle_anchors2 = function() {
    var section;
    if (location.hash.length > 1) {
      section = $(location.hash)[0];
      if (section) {
        scrollTo(section, true);
        slide($("#back_to_top"), {
          right: 25
        });
      }
    } else {
      history.replaceState({
        section: "splash-container"
      }, "splash", "");
    }
    $("a").click(function() {
      var $section;
      section = this.getAttribute("href");
      $section = $("[id=" + (section.substring(1)) + "]");
      if ($section.length > 0) {
        scrollTo($section[0], true);
        slide($("#back_to_top"), {
          right: 25
        });
      }
      return false;
    });
    return $(window).on("popstate", function() {
      var $section;
      if (location.pathname.length > 1) {
        $section = $("[id=" + (location.pathname.substring(1)) + "]");
        if ($section.length > 0) {
          scrollTo($section[0], false);
          return slide($("#back_to_top"), {
            right: 25
          });
        }
      } else {
        return animate_scroll_to(0);
      }
    });
  };

  get_current_section = function() {
    var current_scroll, farthest;
    current_scroll = $("#container").scrollTop();
    farthest = "";
    $(".row").each(function() {
      if (current_scroll >= this.offsetTop - 100) {
        return farthest = this;
      }
    });
    return farthest;
  };

  get_section_after = function(section) {
    return $("#" + section).next(".row");
  };

  get_section_before = function(section) {
    return $("#" + section).prev(".row");
  };

  goToNextSection = function() {
    var next_section;
    next_section = get_section_after(history.state.section)[0];
    if (next_section) {
      animate_scroll_to(next_section.offsetTop);
      history.pushState({
        section: next_section.id
      }, titleize(next_section.id), "#" + ext_section.id);
      return slide($("#back_to_top"), {
        right: 25
      });
    }
  };

  goToPrevSection = function() {
    var prev_section;
    prev_section = get_section_before(history.state.section)[0];
    if (prev_section) {
      animate_scroll_to(prev_section.offsetTop);
      if (prev_section.id === $(".row")[0].id) {
        return scrollToTop();
      } else {
        history.pushState({
          section: prev_section.id
        }, titleize(prev_section.id), "#" + prev_section.id);
        return slide($("#back_to_top"), {
          right: 25
        });
      }
    }
  };

  check_scrolling = function() {
    var current_section;
    current_section = get_current_section();
    if (history.state.section !== current_section.id) {
      if (current_section.id === $(".row")[0].id) {
        history.pushState({
          section: current_section.id
        }, "splash", "/");
        return slide($("#back_to_top"), {
          right: -50
        });
      } else {
        history.pushState({
          section: current_section.id
        }, titleize(current_section.id), "#" + current_section.id);
        return slide($("#back_to_top"), {
          right: 25
        });
      }
    }
  };

  CAN_SCROLL = true;

  SCROLL_DELTA_FACTOR = 1;

  $(function() {
    SCROLL_DELTA_FACTOR = (function() {
      switch ($.client.os) {
        case "Windows":
        case "Linux":
          return 50;
        case "Mac":
          return 1;
      }
    })();
    if (location.hash) {
      setTimeout(function() {
        $("#container").scrollTop(0);
        return handle_anchors2();
      }, 1);
    } else {
      handle_anchors2();
    }
    console.log(titleize("hello friend"));
    $(document.body).keydown(function(e) {
      var $container;
      $container = $("#container");
      switch (e.which) {
        case 13:
          return goToNextSection();
        case 220:
          return goToPrevSection();
        case 38:
          $container.scrollTop($container.scrollTop() - 50);
          return check_scrolling();
        case 40:
          $container.scrollTop($container.scrollTop() + 50);
          return check_scrolling();
        case 72:
          animate_scroll_to(0);
          return history.pushState({
            section: current_section.id
          }, "", "/");
      }
    });
    $(document.body).mousewheel(function(e) {
      var $container, current_scroll;
      if (CAN_SCROLL) {
        $container = $("#container");
        current_scroll = $container.scrollTop();
        $container.scrollTop(current_scroll + (SCROLL_DELTA_FACTOR * -e.deltaY));
        return check_scrolling();
      }
    });
    $("#back_to_top").click(function() {
      return scrollToTop();
    });
    handleCodeStyler();
    $("#name").click(function() {
      CAN_SCROLL = false;
      console.log("Clicked on my name!");
      $("#navbar").css("position", "relative");
      slide($("#navbar"), {
        top: 1000
      }, {
        duration: 1000
      });
      $(this).css("position", "relative");
      return slide(this, {
        top: -1000
      }, {
        done: show_secrets,
        duration: 1000
      });
    });
    return $("#secrets").click(function() {
      console.log("Going back!");
      $(this).fadeOut();
      $("#name, #navbar").show();
      return slide($("#name, #navbar"), {
        top: 0
      }, {
        done: function() {
          return CAN_SCROLL = true;
        },
        duration: 1000
      });
    });
  });

  slide = function(ele, to, options) {
    return $(ele).animate(to, options);
  };

  show_secrets = function() {
    $("#name, #navbar").hide();
    return $("#secrets").fadeIn();
  };

  scrollToTop = function() {
    animate_scroll_to(0);
    history.pushState({
      section: "splash-container"
    }, "splash", "/");
    return slide($("#back_to_top"), {
      right: -100
    });
  };

  handleCodeStyler = function() {
    var $highlights, $select;
    _add_wrapper($(".highlighttable, .highlight:not(td .highlight)"));
    $select = $(".code-box-header > select");
    $select.val(window.localStorage.getItem("style") || "default");
    $select.change(function(e) {
      $select.val(this.value);
      $select.parent().parent().attr("class", "code-box " + this.value);
      return window.localStorage.setItem("style", this.value);
    });
    $select.change();
    $highlights = $(".highlight:not(td .highlight)");
    return $highlights.each(function(idx, ele) {
      var $linenos;
      $linenos = $(ele).find(".lineno");
      $linenos.first().addClass("first");
      return $linenos.last().addClass("last");
    });
  };

  upper = function(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
  };

  _add_wrapper = function(code_blocks) {
    var $block, $box, $header, block, header, lang, new_content, style, _i, _j, _len, _len1, _ref, _results;
    _results = [];
    for (_i = 0, _len = code_blocks.length; _i < _len; _i++) {
      block = code_blocks[_i];
      $block = $(block);
      $box = $("<div>").addClass("code-box default");
      lang = $block.find("code").data("lang");
      header = "<div class=\"code-box-header\">" + (upper(lang)) + "<select>";
      _ref = TYPES.split(' ');
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        style = _ref[_j];
        header += "<option value=\"" + style + "\">" + (upper(style)) + "</option>";
      }
      header += "</select></div>";
      $header = $(header);
      new_content = $box.append($header).append($block.clone());
      _results.push($block.replaceWith(new_content));
    }
    return _results;
  };

}).call(this);
