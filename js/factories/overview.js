angular.module('myApp')

.factory('overview', ['$http', function($http) {
  return $http.get('ajax/getOverview.php')
         .success(function(data) {
           return data;
         });
}]);
