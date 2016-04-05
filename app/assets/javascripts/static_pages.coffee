# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(->
  $("#micropost_content").on("change keyup paste", ->
    left = 140 - $(this).val().length
    $("#micropost_symbol_count").text(left)
  )
)