angular.module('myApp')

.factory('switchesyear', ['$http', function($http) {
  return $http.get('ajax/getSwitchesYear.php')
         .success(function(data) {
           return data;
         })
         .error(function(data) {
           return data;
         });
}]);
