function load_content(url, no_effect)
{
    $.ajax({
        url: url,
        success: function(data) {
            if (!no_effect){
                $("#topframe").slideUp();
                $("#content").removeClass("container-spaced")
                    .addClass("container-wide");
                $("#back").removeClass("hidden").fadeIn();
            }
            $("#content-left").html(data);
            hljs.tabReplace = '    '; //4 spaces
            hljs.initHighlighting();
            $(window).scrollTop(0);
        }
    });
}

if (document.location.hash){
    var url = "/" + document.location.hash.substring(1);
    load_content(url);
    $(".menu-item").removeClass("menu-item-selected");
    $(".menu-item[url=\"" + url + "\"]").addClass("menu-item-selected");
} else {
    hljs.tabReplace = '    '; //4 spaces
    hljs.initHighlighting();
}

$(".menu-item").click(function() {
    var url = $(this).attr("url");
    var target = $(this).attr("target");
    if (target == "blank"){
        window.open(url);
        return;
    }
    document.location.hash = url.substring(1);
    load_content(url);
    $(".menu-item").removeClass("menu-item-selected");
    $(this).addClass("menu-item-selected");
});

$("#back").click(function() {
    load_content("/code", true);
    $("#topframe").slideDown();
    $("#content").removeClass("container-wide").addClass("container-spaced");
    $("#back").removeClass("hidden").fadeOut();
    document.location.hash = "";
    $(".menu-item").removeClass("menu-item-selected");
    $(".menu-item[url=\"/code\"]").addClass("menu-item-selected");
});
