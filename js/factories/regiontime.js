angular.module('myApp')

.factory('regiontime', ['$http', function($http) {
  return $http.get('ajax/getRegiontime.php')
         .success(function(data) {
           return data;
         })
         .error(function(data) {
           return data;
         });
}]);
