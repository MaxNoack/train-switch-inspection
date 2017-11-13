angular.module('myApp')

.factory('inspectionclasses', ['$http', function($http) {
  return $http.get('ajax/getClasses.php')
         .success(function(data) {
           return data;
         })
         .error(function(data) {
           return data;
         });
}]);
