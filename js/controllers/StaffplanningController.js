angular.module('myApp')

.controller('StaffplanningController', ['$scope', '$http', 'staffplanning', 'regions', function ($scope, $http, staffplanning, regions) {

    regions.success(function(data){
        $scope.regions = data;
    });

    $scope.viewedRegion = "Mitt";

    $scope.defaultPlanRegion = "Mitt";
    $scope.showPlanTable = false;  

    $scope.currentvalue = "";
    var isMouseDown = false;
    var currentcolumn = -1;

    $scope.showPlanTableCheck = function(region) {
        if(!region) {
            $scope.showPlanTable = false;
            $scope.viewedRegion = region;
        } else {
            $scope.viewedRegion = region;
       
            $scope.showPlanTable = true;
            var request = $http({
                method: "post",
                url: "ajax/getStaffplanning.php",
                data: {
                    region: region
                },
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            });
            request.success(function (data) {
                $scope.staffplanning = data;
            });
        }
    };

    $scope.updatePlanning = function(week, region, time, columnName, $index) {
        if(!time) {
            time = 0;
        }
        var request = $http({
            method: "post",
            url: "updatePlanning.php",
            data: {
                week: week,
                region: region,
                time: time,
                type: columnName
            },
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        });
        request.success(function (data) {
            //console.log(data);
        });
    };
    
    $scope.mousedown = function(hours, row, col) {
        isMouseDown = true;
        $scope.currentvalue = hours;
        currentcolumn = col;
    };

    $scope.mouseover = function(columnName, row, col) {
      if(isMouseDown){
        if(col == currentcolumn){
            $scope.updatePlanning($scope.staffplanning[row].Week, $scope.viewedRegion, $scope.currentvalue, columnName, row);
            $scope.staffplanning[row][columnName] = $scope.currentvalue;
        }
      } 
    };
      
    $scope.mouseup = function() {
        correntcolumn = -1;
        isMouseDown = false;
        $scope.currentvalue = "";
    };

}]);