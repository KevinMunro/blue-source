$(document).ready ->
  $(window).on "keypress", ->
    $("#search-bar").focus() unless $(".modal").attr("aria-hidden")=="false"
  $(window).on "keydown", (event) ->
    currentPage = angular.element($("section")).scope().currentPage
    if event.keyCode == 39
      $("a[ng-bind]").get(currentPage+1).click() if (currentPage < $("a[ng-bind]").length-1)
    else if event.keyCode == 37
      $("a[ng-bind]").get(currentPage-1).click() if (currentPage > 0)
