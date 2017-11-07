$(window).on("load",  function () {
  labels = document.querySelectorAll("label[for='sn-anything']");
  inputs = document.querySelectorAll("input[id='sn-anything']");

  for (var i = 0; i < labels.length; i++) {
    var string = "sn-"
    var string = string + i.toString()
    labels[i].setAttribute("for", string)
    inputs[i].setAttribute("id", string)
  }; 
});

$(window).on("resize", function() {
  enquire.register("screen and (max-width: 760px)", {
    match : function() {
      $('#blogdesc').insertBefore('.thefooter');
    },
    unmatch : function() {
      $('#blog-p').append($('#blogdesc'));
    }
  });
});

$(window).on("load",  function () {
  $(".thearticle > article > p:nth-of-type(2)").html(function (i, html) {
    return html.replace(/(([α-ωA-Ω]|[a-zA-Z])+\S+\s)/,
      '<span class="newthought">$1</span>')
  });
});

$(window).on("load", function () {
  $("p.caption").each(function (i, html) {
    $(this).insertBefore($(this).prev().parent());
    $(this).replaceWith("<figcaption>"+$(this).text()+"</figcaption>");
  });
});

$.bigfoot();
