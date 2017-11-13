$(function () {
  var isMouseDown = false;
  $("table td")
    .mousedown(function () {
      isMouseDown = true;
      $(this).toggleClass("highlighted");
      return false; // prevent text selection
    })
    .mouseover(function () {
      if (isMouseDown) {
        $(this).toggleClass("highlighted");
      }
    });
  
  $(document)
    .mouseup(function () {
      isMouseDown = false;
    });
});