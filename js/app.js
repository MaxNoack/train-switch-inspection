angular.module('myApp', ['ui.bootstrap'])

.filter('startFrom', function() {
    return function(input, start) {
        if(input) {
            start = +start; //parse to int
            return input.slice(start);
        }
        return [];
    };
})

.filter('testThisYear', function() {
    var thisYear = new Date().getFullYear();
    return function(input) {
        if(input > 0) {
            return input;
        } else {
            return "Ej " + thisYear;
        }
    };
})

.filter('plannedWeek', function() {
    var thisYear = new Date().getFullYear();
    return function(input) {
        if(input > 0) {
            return input;
        } else {
            return "Ej planerad";
        }
    };
})

.filter('checkmark', function() {
     return function(input) {
            if(input.localeCompare('')) {
                return '\u2713';
            }
            return '';
    };
});
