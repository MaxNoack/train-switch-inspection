angular.module('myApp')

.factory('regionswitches', ['$http', function($http) {
  return $http.get('ajax/getRegionswitches.php')
         .success(function(data) {
           return data;
         })
         .error(function(data) {
           return data;
         });
}]);
