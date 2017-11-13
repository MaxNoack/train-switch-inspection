angular.module('myApp')

.factory('weeks', ['$http', function($http) {
  return $http.get('ajax/getWeeks.php')
         .success(function(data) {
           return data;
         })
         .error(function(data) {
           return data;
         });
}]);
