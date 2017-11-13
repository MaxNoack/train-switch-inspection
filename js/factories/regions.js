angular.module('myApp')

.factory('regions', ['$http', function($http) {
  return $http.get('ajax/getRegions.php')
         .success(function(data) {
           return data;
         })
         .error(function(data) {
           return data;
         });
}]);
