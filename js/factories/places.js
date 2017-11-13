angular.module('myApp')

.factory('places', ['$http', function($http) {
  return $http.get('ajax/getPlaces.php')
         .success(function(data) {
           return data;
         })
         .error(function(data) {
           return data;
         });
}]);
