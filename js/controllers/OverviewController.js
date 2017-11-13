angular.module('myApp')

.controller('OverviewController', ['$scope', '$http', '$timeout', 'regions', function ($scope, $http, $timeout, regions) {
	regions.success(function(data){
    	$scope.regions = data;
    });

 

    var now = new Date();
    var onejan = new Date(now.getFullYear(), 0, 1);
    $scope.thisWeek = Math.ceil( (((now - onejan) / 86400000) + onejan.getDay() + 1) / 7 );

    $scope.showTable = false;
    $scope.loading=false;

    $scope.showTested = false;

    $scope.specificSwitches = [];

     $scope.setPage = function(pageNo) {
        $scope.currentPage = pageNo;
    };
    $scope.sort_by = function(predicate) {
        $scope.predicate = predicate;
        $scope.reverse = !$scope.reverse;
    };

	$scope.showLastOverviewTable = function(region) {
        if(!region) {
            $scope.showRegion = "samtliga regioner";
        } else {
            $scope.showRegion = region;
        }
        $scope.loading=true;

	 	var request = $http({
        method: "post",
        url: "ajax/getLastOverview.php",
        data: {
            region: region
        },
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        });
        request.success(function (data) {
            $scope.specificSwitches = data;
            $scope.overview = data;
            $scope.loading = false;
        });

	};

    $scope.getSpecificSwitches = function(region, week, tested, inspectionClass) {
        var request = $http({
        method: "post",
        url: "ajax/getFromOverview.php",
        data: {
            region: region,
            week: week,
            tested: tested,
            inspectionClass: inspectionClass
        },
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        });
        request.success(function (data) {
            $scope.specificSwitches = data;
            $scope.currentPage = 1; //current page
            $scope.entryLimit = 50; //max no of items to display in a page
            $scope.totalItems = $scope.specificSwitches.length;
        });

    };

    $scope.showPlannedOverviewTable = function(region) {

        $scope.loading=true;
        $scope.tableEmpty = true;

        var request = $http({
        method: "post",
        url: "ajax/getPlannedOverview.php",
        data: {
            region: region
        },
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        });
        request.success(function (data) {
            $scope.overview = data;
            if($scope.overview.length > 0) {
                $scope.tableEmpty = false;
            }
            $scope.loading = false;
        });

    };

    $scope.showTestedOverviewTable = function(region) {

        $scope.loading=true;
        $scope.tableEmpty = true;

        var request = $http({
        method: "post",
        url: "ajax/getTestedOverview.php",
        data: {
            region: region
        },
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        });
        request.success(function (data) {
            console.log(data);
            $scope.overview = data;
            if($scope.overview.length > 0) {
                $scope.tableEmpty = false;
            }
            $scope.loading = false;
        });

    };

    $scope.excessTime = function(time) {
        if(time > 0) {
            return false;
        } 
        return true;
    };

}]);