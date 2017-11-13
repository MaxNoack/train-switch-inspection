 <?php
include('../includes/config.php');
$week = date('W');


$postdata = file_get_contents("php://input");
$request = json_decode($postdata);
$region = $request->region;

$region = trim(iconv('utf-8', 'windows-1252', $region));


if($region) {
	$query="select staffplanning.Week as Week, staffplanning.Mondaydate as Mondaydate, IFNULL(Planned.Plannedweek, 0) as Countplanned, IFNULL(Tested.Testedweek,0) as Counttested, IFNULL(Delayedtable.Delayedweek,0) as Countdelayed from staffplanning left join

			(select Week, count(Testedweek) as Testedweek from Staffplanning left join information as Tested on Staffplanning.Week = Tested.Testedweek 
				where staffplanning.Region='" . $region . "' and Tested.Agare='" . $region . "' group by staffplanning.Week) as Tested on staffplanning.Week = Tested.Week left join

			(select Week, count(Plannedweek) as Plannedweek from Staffplanning left join information as Planned on Staffplanning.Week = Planned.Plannedweek 
				where staffplanning.Region='" . $region . "' and Planned.Agare='" . $region . "' group by staffplanning.Week) as Planned on staffplanning.Week = Planned.Week left join 

			(select Week, count(*) as Delayedweek from Staffplanning left join information as Delayedweeks on Staffplanning.Week = Delayedweeks.Plannedweek 
				where staffplanning.Region='" . $region . "' and Delayedweeks.Agare='" . $region . "' and (Delayedweeks.Testedweek > Delayedweeks.Lastweek or (Delayedweeks.Lastweek < '" . $week . "' and Delayedweeks.Testedweek='')) group by staffplanning.Week) as Delayedtable on staffplanning.Week = Delayedtable.Week 

 			where staffplanning.Region='" . $region . "'";
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
