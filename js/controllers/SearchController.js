angular.module('myApp') 


.controller('SearchController', ['$scope', '$http', '$timeout', 'switches', 'places', 'regions', 'trackparts', 'weeks', 'inspectionclasses', function ($scope, $http, $timeout, switches, places, regions, trackparts, weeks, inspectionclasses) {

	$scope.loading = true;
	switches.success(function(data) {
		$scope.list = data;
        $scope.currentPage = 1; //current page
        $scope.entryLimit = 50; //max no of items to display in a page
        $scope.filteredItems = 0; //Initially for no filter  
        $scope.totalItems = $scope.list.length;
	}).finally(function() {
        $timeout(function() { 
            $scope.loading = false;
        }, 0);
    });
	regions.success(function(data){
        $scope.regions = data;
    });
    trackparts.success(function(data){
        $scope.trackParts = data;
    });
    places.success(function(data){
        $scope.places = data;
    });
    weeks.success(function(data){
        $scope.weeks = data;
        $scope.lastWeekOfYear = $scope.weeks[$scope.weeks.length - 1].Week;
    });
    inspectionclasses.success(function(data){
        $scope.iclasses = data;
    });

    $scope.editable = false;
    $scope.currentvalue = "";
    var isMouseDown = false;
    var currentcolumn = -1;


    $scope.thisYear = new Date().getFullYear();
    $scope.testThisYear = true;

    $scope.notTested = false;
    $scope.tested = false;

    $scope.isChecked = false;

    $scope.selectedRegions = [];
    $scope.selectedTrackparts = [];
    $scope.selectedPlaces = [];
    $scope.selectedClasses = ["B1", "B2", "B3", "B4", "B5"];


    $scope.setPage = function(pageNo) {
        $scope.currentPage = pageNo;
    };
    $scope.filter = function() {
        $timeout(function() { 
            $scope.filteredItems = $scope.filtered.length;
        }, 10);
    };
    $scope.sort_by = function(predicate) {
        $scope.predicate = predicate;
        $scope.reverse = !$scope.reverse;
    };

    $scope.addRegion = function(region) {
        if(!$scope.loading && !$scope.editable) {
            var exists = false;
            for(var i = 0; i < $scope.selectedRegions.length; i ++) {
                if(region == $scope.selectedRegions[i]) {
                    $scope.selectedRegions.splice(i, 1);
                    exists = true;
                }
            }
            if(!exists) {
                $scope.selectedRegions.splice(0, 0, region);
            }
            $scope.filter();           
        }
    };

    $scope.addTrackpart = function(trackpart) {
        if(!$scope.editable) {
            var exists = false;
            for(var i = 0; i < $scope.selectedTrackparts.length; i ++) {
                if(trackpart == $scope.selectedTrackparts[i]) {
                    $scope.selectedTrackparts.splice(i, 1);
                    exists = true;
                }
            }
            if(!exists) {
                $scope.selectedTrackparts.splice(0, 0, trackpart);
            }
            //$scope.selectedTrackparts.sort();
            $scope.filter();
        }
    };

    $scope.addPlace = function(place) {
        if(!$scope.editable) {
            var exists = false;
            for(var i = 0; i < $scope.selectedPlaces.length; i ++) {
                if(place == $scope.selectedPlaces[i]) {
                    $scope.selectedPlaces.splice(i, 1);
                    exists = true;
                }
            }
            if(!exists) {
                $scope.selectedPlaces.splice(0, 0, place);
            }
            //$scope.selectedPlaces.sort();
            $scope.filter();
        }
    };

    $scope.addClass = function(iclass) {
        if(!$scope.loading && !$scope.editable) {
            var exists = false;
            for(var i = 0; i < $scope.selectedClasses.length; i ++) {
                if(iclass == $scope.selectedClasses[i]) {
                    $scope.selectedClasses.splice(i, 1);
                    exists = true;
                }
            }
            if(!exists) {
                $scope.selectedClasses.splice(0, 0, iclass);
            }
            $scope.filter();
        }
    };


    $scope.basicFilter = function(filterMe) {
        for(var r = 0; r < $scope.selectedRegions.length; r++) {
            if(filterMe.Agare == $scope.selectedRegions[r]) {

                for(var t = 0; t < $scope.selectedTrackparts.length; t++) {
                    if(filterMe.Bdl == $scope.selectedTrackparts[t]) {

                        for(var p = 0; p < $scope.selectedPlaces.length; p++) {
                            if(filterMe.TplStr == $scope.selectedPlaces[p]) {

                                for(var c = 0; c < $scope.selectedClasses.length; c++) {
                                    if(filterMe.Bklass == $scope.selectedClasses[c]) {
                                        return true;
                                    }
                                }
                                return false;
                            }
                        }
                        return false;
                    }
                }
                return false;
            }
        }
        return false;
    };

     $scope.detailedFilter = function(filterMe) {
        if(($scope.testThisYear && filterMe.Lastweek > 0) || !$scope.testThisYear) {

            if(($scope.notTested && filterMe.Tested === '') || !$scope.notTested) {
            
                if(($scope.tested && filterMe.Tested !== '') || !$scope.tested) {
            
                     if(!$scope.startExpirationWeek || ($scope.startExpirationWeek.Week && (Number($scope.startExpirationWeek.Week) <= Number(filterMe.Lastweek)))) {
            
                        if(!$scope.endExpirationWeek || ($scope.endExpirationWeek.Week && (Number($scope.endExpirationWeek.Week) >= Number(filterMe.Lastweek)))) {
            
                            if(!$scope.startPlannedWeek || ($scope.startPlannedWeek.Week && (Number($scope.startPlannedWeek.Week) <= Number(filterMe.Plannedweek)))) {
            
                                if(!$scope.endPlannedWeek || ($scope.endPlannedWeek.Week && (Number($scope.endPlannedWeek.Week) >= Number(filterMe.Plannedweek)))) {
                                    return true;    
                                }
                                return false;
                            }
                            return false;        
                        }
                        return false;
                    }
                    return false;    
                }
                return false;
            }
            return false;
        }
        return false;
    };


    $scope.endWeekFilter = function(startWeek) {
        return function(week) {
            if(Number(week.Week) >= Number(startWeek)) {
                return true;
            } 
            if(week.Week == $scope.lastWeekOfYear) {
                return true;
            }
            return false;
        };
    };

    $scope.trackpartFilter = function(filterMe) {
        for(var r = 0; r < $scope.selectedRegions.length; r++) {
            if(filterMe.Agare == $scope.selectedRegions[r]) return true;
        }
        return false;
    };

    $scope.placeFilter = function(filterMe) {
        for(var r = 0; r < $scope.selectedRegions.length; r++) {
            if(filterMe.Agare == $scope.selectedRegions[r]) {
                for(var t = 0; t < $scope.selectedTrackparts.length; t++) {
                    if(filterMe.Bdl == $scope.selectedTrackparts[t]) {
                        return true;
                    }
                }
                return false;
            }
        }
    };

    $scope.checkRegion = function(region) {
        if(!$scope.loading) {
            for(var r = 0; r < $scope.selectedRegions.length; r++) {
                if(region == $scope.selectedRegions[r]) {
                    return true;
                }
            }
            return false;
        }
    };

    $scope.checkClass = function(inspectionclass) {
        for(var c = 0; c < $scope.selectedClasses.length; c++) {
            if(inspectionclass == $scope.selectedClasses[c]) {
                return true;
            }
        }
        return false;
    };

    $scope.checkTrackpart = function(trackpart) {
        for(var t = 0; t < $scope.selectedTrackparts.length; t++) {
            if(trackpart == $scope.selectedTrackparts[t]) {
                return true;
            }
        }
        return false;
    };

    $scope.checkPlace = function(place) {
        for(var p = 0; p < $scope.selectedPlaces.length; p++) {
            if(place == $scope.selectedPlaces[p]) {
                return true;
            }
        }
        return false;
    };

    $scope.selectAllRegions = function(regions) {
        if(!$scope.loading && !$scope.editable) {
            var allSelected = true; 
            for(var t = 0; t < regions.length; t++) {
                var exists = false;
                for(var i = 0; i < $scope.selectedRegions.length; i ++) {
                    if(regions[t].Agare == $scope.selectedRegions[i]) {
                        exists = true;
                    }
                }
                if(!exists) {
                    allSelected = false;
                    $scope.selectedRegions.splice(0, 0, regions[t].Agare);
                }
            }
            if(allSelected) {
                $scope.selectedRegions.splice(0, $scope.selectedRegions.length);
            }
            $scope.filter();
        }
    };

    $scope.selectAllClasses = function(classes) {
        if(!$scope.loading && !$scope.editable) {
            var allSelected = true; 
            for(var t = 0; t < classes.length; t++) {
                var exists = false;
                for(var i = 0; i < $scope.selectedClasses.length; i ++) {
                    if(classes[t].Bklass == $scope.selectedClasses[i]) {
                        exists = true;
                    }
                }
                if(!exists) {
                    allSelected = false;
                    $scope.selectedClasses.splice(0, 0, classes[t].Bklass);
                }
            }
            if(allSelected) {
                $scope.selectedClasses.splice(0, $scope.selectedClasses.length);
            }
            $scope.filter();
        }
    };

    $scope.selectAllTrackparts = function(tracks) {
        if(!$scope.editable){
            var allSelected = true; 
            for(var t = 0; t < tracks.length; t++) {
                var exists = false;
                for(var i = 0; i < $scope.selectedTrackparts.length; i ++) {
                    if(tracks[t].Bdl == $scope.selectedTrackparts[i]) {
                        exists = true;
                    }
                }
                if(!exists) {
                    allSelected = false;
                    $scope.selectedTrackparts.splice(0, 0, tracks[t].Bdl);
                }
            }
            if(allSelected) {
                for(var ts = 0; ts < tracks.length; ts++) {
                    for(var s = 0; s < $scope.selectedTrackparts.length; s++) {
                        if(tracks[ts].Bdl == $scope.selectedTrackparts[s]) {
                            $scope.selectedTrackparts.splice(s, 1);
                        }
                    }
                }
            }
            $scope.filter();
        }
    };

    $scope.checkAllRegions = function(regions) {
        if(regions) {
            for(var i = 0; i < regions.length; i++) {
                var exists = false;
                for(var t = 0; t < $scope.selectedRegions.length; t++) {
                    if(regions[i].Agare == $scope.selectedRegions[t]) {
                        exists = true;
                    }
                }
                if(!exists) {
                    return false;
                }
            }
            return true;
        }
        return false;
    };

    $scope.checkAllClasses = function(classes) {
        if(classes) {
            for(var i = 0; i < classes.length; i++) {
                var exists = false;
                for(var t = 0; t < $scope.selectedClasses.length; t++) {
                    if(classes[i].Bklass == $scope.selectedClasses[t]) {
                        exists = true;
                    }
                }
                if(!exists) {
                    return false;
                }
            }
            return true;
        }
        return false;
    };

    $scope.checkAllTrackparts = function(tracks) {
        if(tracks) {
            for(var i = 0; i < tracks.length; i++) {
                var exists = false;
                for(var t = 0; t < $scope.selectedTrackparts.length; t++) {
                    if(tracks[i].Bdl == $scope.selectedTrackparts[t]) {
                        exists = true;
                    }
                }
                if(!exists) {
                    return false;
                }
            }
            return true;
        }
        return false;
    };

    $scope.selectAllPlaces = function(places) {
        if(!$scope.editable) { 
            var allSelected = true; 
            for(var p = 0; p < places.length; p++) {
                var exists = false;
                for(var i = 0; i < $scope.selectedPlaces.length; i ++) {
                    if(places[p].TplStr == $scope.selectedPlaces[i]) {
                        exists = true;
                    }
                }
                if(!exists) {
                    allSelected = false;
                    $scope.selectedPlaces.splice(0, 0, places[p].TplStr);
                }
            }
            if(allSelected) {
                for(var ps = 0; ps < places.length; ps++) {
                    for(var s = 0; s < $scope.selectedPlaces.length; s++) {
                        if(places[ps].TplStr == $scope.selectedPlaces[s]) {
                            $scope.selectedPlaces.splice(s, 1);
                        }
                    }
                }
            }
            $scope.filter();
        }
    };

    $scope.checkAllPlaces = function(places) {
        if(places) {
            for(var i = 0; i < places.length; i++) {
                var exists = false;
                for(var p = 0; p < $scope.selectedPlaces.length; p++) {
                    if(places[i].TplStr == $scope.selectedPlaces[p]) {
                        exists = true;
                    }
                }
                if(!exists) {
                    return false;
                }
            }
            return true;
        }
        return false;
    };

    $scope.removeAllTrackparts = function() {
        if(!$scope.editable) {
            $scope.selectedTrackparts.splice(0, $scope.selectedTrackparts.length);
            $scope.filter();
        }
    };

    $scope.removeAllPlaces = function() {
        if(!$scope.editable) {
            $scope.selectedPlaces.splice(0, $scope.selectedPlaces.length);
            $scope.filter();
        }
    };

    $scope.toggleTestThisYear = function() {
        if($scope.selectedRegions.length > 0 && $scope.selectAllTrackparts.length > 0 && $scope.selectedPlaces.length > 0 && !$scope.editable) {
            if($scope.testThisYear) {
                $scope.testThisYear = false;
                $scope.startExpirationWeek = "";
                $scope.startPlannedWeek = "";
                $scope.endExpirationWeek = "";
                $scope.endPlannedWeek = "";
            } else {
                $scope.testThisYear = true;
            }
            $scope.filter();
        }
    };

    $scope.toggleNotTested = function() {
        if($scope.selectedRegions.length > 0 && $scope.selectAllTrackparts.length > 0 && $scope.selectedPlaces.length > 0 && !$scope.editable) {
            if($scope.notTested) {
                $scope.notTested = false;
            } else {
                $scope.notTested = true;
                if($scope.tested) {
                    $scope.tested = false;
                }
            }
            $scope.filter();
        }
    };

    $scope.toggleTested = function() {
        if($scope.selectedRegions.length > 0 && $scope.selectAllTrackparts.length > 0 && $scope.selectedPlaces.length > 0 && !$scope.editable) {
            if($scope.tested) {
                $scope.tested = false;
            } else {
                $scope.tested = true;
                if($scope.notTested) {
                    $scope.notTested = false;
                }
            }
            $scope.filter();
        }
    };

    $scope.checkExpirationWeek = function(startExpirationWeek) {
        if($scope.endExpirationWeek && Number(startExpirationWeek) >= Number($scope.endExpirationWeek.Week)) {
            $scope.endExpirationWeek = $scope.weeks[startExpirationWeek - 1];
        }
        if(startExpirationWeek && !$scope.testThisYear) {
            $scope.testThisYear = true;
        }
        if(!startExpirationWeek) {
            $scope.endExpirationWeek = "";
        }
    };

    $scope.checkPlannedWeek = function(startPlannedWeek) {
        if($scope.endPlannedWeek && Number(startPlannedWeek) >= Number($scope.endPlannedWeek.Week)) {
            $scope.endPlannedWeek = $scope.weeks[startPlannedWeek - 1];
        }
        if(!startPlannedWeek) {
            $scope.endPlannedWeek = "";
        }
    };

    $scope.exportData = function () {
        alasql('SELECT Bdl, TplStr, Typ, UNE, Sparnr, Agare, '+
            'Bklass, Mall, Benamning, Kmmfr, Kmmti, Recentdate, '+
            'Nextdate, Lastdate, Lastweek, Plannedweek, Tested '+
            'INTO XLSX("Filtrerad.xlsx",{headers:true}) FROM ?',[$scope.filtered]);
    };

    $scope.toggleEditable = function() {
        if(!$scope.editable) {
            if(confirm("Är du säker på att du vill gå in i redigeringsläge?")) {
                $scope.editable = true;
                $scope.edited = $scope.filtered;
            }
        } else {
            $scope.editable = false;
            switches.success(function(data) {
                $scope.list = data;
                $scope.currentPage = 1; //current page
                $scope.entryLimit = 50; //max no of items to display in a page
                $scope.filteredItems = 0; //Initially for no filter  
                $scope.totalItems = $scope.list.length;
            }).finally(function() {
                $timeout(function() { 
                    $scope.filter();
                }, 0);
            });
        }
    };

    $scope.updatePlannedWeek = function(id, plannedWeek) {
        if(!plannedWeek) {
            plannedWeek = 0;
        }
        var request = $http({
            method: "post",
            url: "updatePlannedWeek.php",
            data: {
                id: id,
                plannedWeek: plannedWeek
            },
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        });
        request.success(function (data) {
            //console.log(data);
        });
    };

    $scope.updateTestedDate = function(id, testDate) {
        if(!testDate) {
            testDate = 0;
        }
        var request = $http({
            method: "post",
            url: "updateTestedDate.php",
            data: {
                id: id,
                testDate: testDate
            },
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        });
        request.success(function (data) {
            if(data.trim() === 'INTE OK') {
                $scope.dateNotOk = true;
            } else if(data.trim() === 'OK') {
                $scope.dateNotOk = false;
            }
        });
    };


    $scope.mousedown = function(value, col) {
        isMouseDown = true;
        $scope.currentvalue = value;
        currentcolumn = col;
    };

    $scope.mouseover = function(columnName, id, col, row) {
      if(isMouseDown){
        if(col == currentcolumn){
            if(col == 1) {
                $scope.updatePlannedWeek(id, $scope.currentvalue);
                if($scope.editable) {
                    $scope.filteredStatic[row+(($scope.currentPage-1)*$scope.entryLimit)][columnName] = $scope.currentvalue;
                } else {
                    $scope.filtered[row+(($scope.currentPage-1)*$scope.entryLimit)][columnName] = $scope.currentvalue;
                }
            } else if (col == 2) {
                $scope.updateTestedDate(id, $scope.currentvalue);
                if($scope.editable) {
                    $scope.filteredStatic[row+(($scope.currentPage-1)*$scope.entryLimit)][columnName] = $scope.currentvalue;
                } else {
                    $scope.filtered[row+(($scope.currentPage-1)*$scope.entryLimit)][columnName] = $scope.currentvalue;
                }    
            }            
        }
      } 
    };
      
    $scope.mouseup = function() {
        currentcolumn = -1;
        isMouseDown = false;
        $scope.currentvalue = "";
    };

}]);


