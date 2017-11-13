angular.module('myApp')

.controller('SwitchplanningController',  ['$scope', '$http', '$timeout', 'staffplanning', 'switchesyear', function ($scope, $http, $timeout, staffplanning, switchesyear) {
	$scope.loading = true;
	staffplanning.success(function(data) {
		$scope.regionTime = data;
	});
	switchesyear.success(function(data) {
		$scope.switches = data;
	}).finally(function() {
		$scope.loading = false;
	});

	$scope.sort_by = function(predicate) {
        $scope.predicate = predicate;
        $scope.reverse = !$scope.reverse;
    };

    $scope.setPage = function(pageNo) {
        $scope.currentPage = pageNo;
    };



	$scope.numberOfAjaxCalls = 0;
	$scope.currentAjaxCall = 0;
	$scope.barType = 'warning';

	$scope.currentvalue = "";
    var isMouseDown = false;
    var currentcolumn = -1;

	$scope.delayedSwitches = [];

	$scope.currentPage = 1; //current page
    $scope.entryLimit = 20; //max no of items to display in a page
    $scope.totalItems = $scope.delayedSwitches.length;

	var now = new Date();
	var onejan = new Date(now.getFullYear(), 0, 1);
	$scope.thisWeek = Math.ceil( (((now - onejan) / 86400000) + onejan.getDay() + 1) / 7 );

	$scope.planRegion = function(region) {
		
		$scope.selectedRegionTime = [];
		$scope.transferTime(region);
		$scope.selectedRegionSwitches = [];
		$scope.transferSwitches(region);
		var totalPlannedTime = $scope.getRegionTime(region);
		$scope.totalNumberOfSwitches = $scope.selectedRegionSwitches.length;
		var accept = true;

		if(totalPlannedTime < 0.7*$scope.totalNumberOfSwitches) {
			accept = false;
			alert("För lite tid inplanerat. Det fattas " + Math.ceil(0.7*$scope.totalNumberOfSwitches - totalPlannedTime) + " timmar.");
		} else {

			$scope.plannedSwitches = [];
			var stopLoop = 0;
			$scope.planFirstLap();
			while($scope.selectedRegionSwitches.length > 0 && stopLoop < 4) {	
				$scope.addTimeForWeeks();
				$scope.planOtherLap();
				stopLoop++;			
			}

			if($scope.selectedRegionSwitches.length) {
				if(!confirm("Det finns växlar som inte kommer kunna planeras. Vill du mata in planeringen för övriga växlar i databasen?")) {
					accept = false;
				}	
			}
			
			if(accept) {
				$scope.currentAjaxCall = 0;
				$scope.progress = 0;
				$scope.delayedSwitches = $scope.selectedRegionSwitches;
				$scope.totalItems = $scope.delayedSwitches.length;
				$scope.numberOfAjaxCalls = $scope.plannedSwitches.length;
				for(var k = 0; k < $scope.plannedSwitches.length; k++) {
					$scope.setPlannedWeek($scope.plannedSwitches[k].id, $scope.plannedSwitches[k].week);
				}
				// redirecta till översiktssida med tid/planering.
			}
		}
		for(var l = 0; l < $scope.selectedRegionTime.length; l++) {
			// hantera skillnaden på tid från start och när planeringen är färdig.
		}
	};	

	$scope.getRegionTime = function(region) {
		var totalTime = 0;
		for(var i = 0; i < $scope.selectedRegionTime.length; i++) {
			totalTime += Number($scope.selectedRegionTime[i].Switches);
		}
		return totalTime;
	};

	$scope.transferSwitches = function(region) {
		for(var j = 0; j < $scope.switches.length; j++) {
			if($scope.switches[j].Agare == region) {
				$scope.selectedRegionSwitches.push($scope.switches[j]);
			}
		}
	};

	$scope.transferTime = function(region) {
		for(var k = 0; k < $scope.regionTime.length; k++) {			
			if($scope.regionTime[k].Region == region) {
				$scope.selectedRegionTime.push({Week: $scope.regionTime[k].Week, Switches: $scope.regionTime[k].Switches});
			}
		}
	};

	$scope.planFirstLap = function() {
		$scope.plannedSwitches.length = 0;	
		for(var i = 0; i < $scope.selectedRegionSwitches.length; i++) {
			var temp = $scope.selectedRegionSwitches[i];
			var firstWeek = $scope.getFirstWeek(temp.Lastweek);
			var week = $scope.getFirstPlannableWeek(firstWeek, temp.Lastweek).Week;
			var place = temp.TplStr;			
			if($scope.selectedRegionSwitches.length > 0) {
				for(var j = i+1; j < $scope.selectedRegionSwitches.length; j++) {
					var tempSwitch = $scope.selectedRegionSwitches[j];
					var tempFirstWeek = $scope.getFirstWeek(tempSwitch.Lastweek);
					if(tempSwitch.TplStr == place && week >= Number(tempFirstWeek) && week <= Number(tempSwitch.Lastweek)) {
						var tempWeek = $scope.getFirstPlannableWeek(week, tempSwitch.Lastweek).Week;
						if(tempWeek > 0) {
							$scope.plannedSwitches.push({id: tempSwitch.id, week: tempWeek, place: tempSwitch.TplStr});
							$scope.selectedRegionSwitches.splice(j, 1);
							j--;
						}
					}
				}
			}			
			if(week > 0) {
				$scope.plannedSwitches.push({id: temp.id, week: week, place: temp.TplStr});
				$scope.selectedRegionSwitches.splice(i, 1);
				i--;
			}		
		}
	};

	$scope.planOtherLap = function() {
		for(var i = 0; i < $scope.selectedRegionSwitches.length; i++) {
			var temp = $scope.selectedRegionSwitches[i];
			var firstWeek = $scope.getFirstWeek(temp.Lastweek);
			var place = temp.TplStr;
			var found = false;
			for(var j = 0; j < $scope.plannedSwitches.length; j++) {
				var tempSwitch = $scope.plannedSwitches[j];
				if(tempSwitch.place == place && tempSwitch.week >= firstWeek && tempSwitch.week <= temp.Lastweek) {
					var tempWeek = tempSwitch.week;
					var success = $scope.removeTimeForWeek(tempWeek);
					if(!success) {
						tempWeek = $scope.getFirstPlannableWeek(firstWeek, temp.Lastweek).Week;
					} 
					if(tempWeek > 0) {
						$scope.plannedSwitches.push({id: temp.id, week: tempWeek, place: place});					
						$scope.selectedRegionSwitches.splice(i, 1);
						i--;
					}					
					found = true;
					break;
				}
			}
			if(!found) {
				var week = $scope.getFirstPlannableWeek(firstWeek, temp.Lastweek).Week;
				if(week > 0) {
					$scope.plannedSwitches.push({id: temp.id, week: week, place: temp.TplStr});
					$scope.selectedRegionSwitches.splice(i, 1);
					i--;
				}
			}
		}
	};

	$scope.getFirstWeek = function(lastWeek) {
		var firstWeek = Number(lastWeek) - 16;
		if(firstWeek < 1) {
			return 1;
		} 
		return firstWeek;
	};

	$scope.getFirstPlannableWeek = function(firstWeek, lastWeek) {
		for(var i = 0; i < $scope.selectedRegionTime.length; i++) {
			if(Number($scope.selectedRegionTime[i].Week) >= firstWeek && Number($scope.selectedRegionTime[i].Week) <= lastWeek && Number($scope.selectedRegionTime[i].Week) >= $scope.thisWeek) {
				if($scope.selectedRegionTime[i].Switches > 0.7) {
					$scope.selectedRegionTime[i].Switches -= 0.7;
					return $scope.selectedRegionTime[i];
				}
			}			
		}
		return {Week: 0, Switches: 0};
	};

	$scope.removeTimeForWeek = function(week) {
		for(var i = 0; i < $scope.selectedRegionTime.length; i++) {
			if(Number($scope.selectedRegionTime[i].Week) == week) {
				if($scope.selectedRegionTime[i].Switches > 0.7) {
					$scope.selectedRegionTime[i].Switches -= 0.7;
					return true;
				}
				return false;
			}			
		}
	};

	$scope.addTimeForWeeks = function() {
		for(var i = 0; i < $scope.selectedRegionTime.length; i++) {
			if($scope.selectedRegionTime[i].Switches > 0) {
				$scope.selectedRegionTime[i].Switches = Number($scope.selectedRegionTime[i].Switches); 
				$scope.selectedRegionTime[i].Switches += 26;
			}
		}
	};

	function setPlannedWeek(id, week) {
	  
	 }

	$scope.setPlannedWeek = function(id, week) {
		$.ajax({
	    type: "POST",
	    data: { id: id, week : week} ,
	    url: "setPlannedWeek.php",
	    success: function(data) {
	        $scope.$apply(function() {
		      	$scope.currentAjaxCall++;
		      	$scope.progress = $scope.currentAjaxCall/$scope.numberOfAjaxCalls*100;
		      	if($scope.progress == 100) {
		      		 $timeout(function() { 
			            $scope.barType = 'success';
			        }, 500);		      		
		      	} else {
		      		$scope.barType = 'warning';
		      	}
	      	});
	    },
	    error: function(data) {
	      // Stuff
	    }
	  });
	};

	$scope.getNumberOfUnplannedSwitches = function(idWeek) {
		var toReturn = 0;
		for(var i = 0; i < idWeek.length; i++) {
			if(Number(idWeek[i].week) === 0) {
				toReturn++;
			}
		}
		return toReturn;
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


    $scope.mousedown = function(week, col) {
        isMouseDown = true;
        $scope.currentvalue = week;
        currentcolumn = col;
    };

    $scope.mouseover = function(columnName, id, plannedWeek, col, row) {
      if(isMouseDown){
        if(col == currentcolumn){
            $scope.updatePlannedWeek(id, $scope.currentvalue);
            $scope.delayedSwitches[row+(($scope.currentPage-1)*$scope.entryLimit)][columnName] = $scope.currentvalue;
            
        }
      } 
    };
      
    $scope.mouseup = function() {
        currentcolumn = -1;
        isMouseDown = false;
        $scope.currentvalue = "";
    };
}]);