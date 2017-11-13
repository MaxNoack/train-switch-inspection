angular.module('myApp')

.factory('trackparts', ['$http', function($http) {
  return $http.get('ajax/getTrackparts.php')
         .success(function(data) {
           return data;
         })
         .error(function(data) {
           return data;
         });
}]);
