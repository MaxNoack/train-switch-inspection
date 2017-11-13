angular.module('myApp')

.factory('staffplanning', ['$http', function($http) {
  return $http.get('ajax/getStaffplanning.php')
         .success(function(data) {
           return data;
         })
         .error(function(data) {
           return data;
         });
}]);
