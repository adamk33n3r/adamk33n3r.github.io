---
title: GameJamFall2014
layout: default
---
{{ page.author }}

{% highlight javascript linenos %}
$(function() {
    console.log("Hello World!");
});
{% endhighlight %}

{% highlight ruby linenos %}
def show
  @widget = Widget(params[:id])
  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @widget }
  end
end
{% endhighlight %}

{% highlight coffeescript linenos %}
$ ->
  $("a").click ->
    return false
{% endhighlight %}
{% highlight javascript linenos %}
$(function() {
    $("a").click(function() {
        return false;
    }
});
{% endhighlight %}
