angular.module('myApp')

.factory('switches', ['$http', function($http) {
  return $http.get('ajax/getSwitches.php')
         .success(function(data) {
           return data;
         })
         .error(function(data) {
           return data;
         });
}]);
