function buildInformation() {
  $.ajax({
    type: "POST",
    url: "buildInformation.php",
    beforeSend : fnLoadStart,
    success: function(data) {
      fnLoadStop();
      // alert(data);
    },
    error: function(data) {
      // Stuff
    }
  });

}

function fnLoadStart() {
     $("#loading").show();  // this div should have loader gif
}
function fnLoadStop() {
    $("#loading").hide();  
}

function buildStaffplanning() {
  $.ajax({
    type: "POST",
    url: "buildStaffplanning.php",
    beforeSend : fnLoadStart,
    success: function(data) {
      fnLoadStop();
      // alert(data);
    },
    error: function(data) {
      // Stuff
    }
  });

}

$(document).ready(function($) {
    var element = $('#follow-scroll'),
        originalY = element.offset().top;

     

    // Space between element and top of screen (when scrolling)
    var topMargin = 20;

    // Should probably be set in CSS; but here just for emphasis
    element.css('position', 'relative');

    $(window).on('scroll', function(event) {
        var scrollTop = $(window).scrollTop();
        var specificTable = $('#specificSwitchesTable'),
          specificTableY = specificTable.offset().top;

        element.stop(false, false).animate({
            top: scrollTop < originalY || scrollTop > specificTableY - 130
                    ? 0
                    : scrollTop - originalY + topMargin
        }, 300);
    });
})(jQuery);