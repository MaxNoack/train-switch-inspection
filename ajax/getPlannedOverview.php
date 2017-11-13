<?php
include('../includes/config.php');
$year = date('Y');
$firstDayOfNextYear = date('Y-m-d', mktime(0, 0, 0, 1, 1, $year + 1));


$postdata = file_get_contents("php://input");
$request = json_decode($postdata);
$region = $request->region;

$region = trim(iconv('utf-8', 'windows-1252', $region));


if($region) {
	$query="select distinct(staffplanning.Week) as week, staffplanning.Mondaydate as mondaydate, IFNULL(countPlannedRegion, 0) as countPlannedRegion, IFNULL(countTestedRegion, 0) as countTestedRegion, IFNULL(round(countPlannedRegion*0.7), 0) as occupiedTimeRegion, IFNULL(TimeRegion.Switches, 0) as timePlanned, 
			IFNULL(round(IFNULL(countPlannedRegion, 0)*0.7) - IFNULL(TimeRegion.Switches, 0), 0) as missingHours, 
			IFNULL(round(round(countPlannedRegion*0.7)/TimeRegion.Switches*100), 0) as ratio from staffplanning left join 
			(select Week, count(Plannedweek) as countPlannedRegion from Staffplanning left join information as Planned on Staffplanning.Week = Planned.Plannedweek 
				where staffplanning.Region='" . $region . "' and Planned.Agare='" . $region . "' group by staffplanning.Week) as Planned on staffplanning.Week = Planned.Week left join 
			(select Week, count(Testedweek) as countTestedRegion from Staffplanning left join information as Tested on Staffplanning.Week = Tested.Testedweek 
				where staffplanning.Region='" . $region . "' and Tested.Agare='" . $region . "' group by staffplanning.Week) as Tested on staffplanning.Week = Tested.Week left join
			(select Week, Switches from staffplanning where Region = '" . $region . "') as TimeRegion on staffplanning.Week = TimeRegion.Week group by staffplanning.Week";
} 

$result = $mysqli->query($query) or die($mysqli->error.__LINE__);

$arr = array();
if($result->num_rows > 0) {
	while($row = $result->fetch_assoc()) {
		$arr[] = $row;	
	}
}
array_walk_recursive($arr, function(&$value, $key) {
    if (is_string($value)) {
        $value = iconv('windows-1252', 'utf-8', $value);
    }
});

# JSON-encode the response
$json_response = json_encode($arr);

// # Return the response
echo $json_response;
?>
