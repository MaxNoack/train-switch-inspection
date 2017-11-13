<?php
include('../includes/config.php');
$year = date('Y');
$firstDayOfNextYear = date('Y-m-d', mktime(0, 0, 0, 1, 1, $year + 1));


$postdata = file_get_contents("php://input");
$request = json_decode($postdata);
$region = $request->region;

$region = trim(iconv('utf-8', 'windows-1252', $region));


if($region) {
	$query="select distinct(staffplanning.Week) as week, staffplanning.Mondaydate as mondaydate, Totregion45, Totregion3, Totregion12, Testregion45, Testregion3, Testregion12, Untestregion45, Untestregion3, Untestregion12, 
			(IFNULL(Totregion45, 0) + IFNULL(Totregion3, 0) + IFNULL(Totregion12, 0)) as countTotal,
			(round((IFNULL(Totregion45, 0) + IFNULL(Totregion3, 0) + IFNULL(Totregion12, 0))*0.7)) as hoursTotal from staffplanning left join 
			
			(select Week, count(*) as Totregion from staffplanning left join information as Region on staffplanning.Week = Region.Lastweek where staffplanning.Region='" . $region . "' and Region.Agare='" . $region . "' group by staffplanning.Week) 
			as Region1 on staffplanning.Week = Region1.Week left join 


			(select Week, count(*) as Totregion45 from staffplanning left join information as Regiont45 on staffplanning.Week = Regiont45.Lastweek where staffplanning.Region='" . $region . "' and Regiont45.Agare='" . $region . "' and (Regiont45.Bklass = 'B5' or Regiont45.Bklass = 'B4') group by staffplanning.Week) 
			as RegionTot45 on staffplanning.Week = RegionTot45.Week left join
			(select Week, count(*) as Totregion3 from staffplanning left join information as Regiont3 on staffplanning.Week = Regiont3.Lastweek where staffplanning.Region='" . $region . "' and Regiont3.Agare='" . $region . "' and (Regiont3.Bklass = 'B3') group by staffplanning.Week) 
			as RegionTot3 on staffplanning.Week = RegionTot3.Week left join
			(select Week, count(*) as Totregion12 from staffplanning left join information as Regiont12 on staffplanning.Week = Regiont12.Lastweek where staffplanning.Region='" . $region . "' and Regiont12.Agare='" . $region . "' and (Regiont12.Bklass = 'B2' or Regiont12.Bklass = 'B1') group by staffplanning.Week) 
			as RegionTot12 on staffplanning.Week = RegionTot12.Week left join

			(select Week, count(*) as Testregion45 from staffplanning left join information as Regiontest45 on staffplanning.Week = Regiontest45.Lastweek where staffplanning.Region='" . $region . "' and Regiontest45.Agare='" . $region . "' and Tested != '' and (Regiontest45.Bklass = 'B5' or Regiontest45.Bklass = 'B4') group by staffplanning.Week) 
			as RegionTested45 on staffplanning.Week = RegionTested45.Week left join
			(select Week, count(*) as Testregion3 from staffplanning left join information as Regiontest3 on staffplanning.Week = Regiontest3.Lastweek where staffplanning.Region='" . $region . "' and Regiontest3.Agare='" . $region . "' and Tested != '' and (Regiontest3.Bklass = 'B3') group by staffplanning.Week) 
			as RegionTested3 on staffplanning.Week = RegionTested3.Week left join
			(select Week, count(*) as Testregion12 from staffplanning left join information as Regiontest12 on staffplanning.Week = Regiontest12.Lastweek where staffplanning.Region='" . $region . "' and Regiontest12.Agare='" . $region . "' and Tested != '' and (Regiontest12.Bklass = 'B2' or Regiontest12.Bklass = 'B1') group by staffplanning.Week) 
			as RegionTested12 on staffplanning.Week = RegionTested12.Week left join

			(select Week, count(*) as Untestregion45 from staffplanning left join information as Regionu45 on staffplanning.Week = Regionu45.Lastweek where staffplanning.Region='" . $region . "' and Regionu45.Agare='" . $region . "' and Tested = '' and (Regionu45.Bklass = 'B5' or Regionu45.Bklass = 'B4') group by staffplanning.Week) 
			as RegionUntested45 on staffplanning.Week = RegionUntested45.Week left join
			(select Week, count(*) as Untestregion3 from staffplanning left join information as Regionu3 on staffplanning.Week = Regionu3.Lastweek where staffplanning.Region='" . $region . "' and Regionu3.Agare='" . $region . "' and Tested = '' and (Regionu3.Bklass = 'B3') group by staffplanning.Week) 
			as RegionUntested3 on staffplanning.Week = RegionUntested3.Week left join
			(select Week, count(*) as Untestregion12 from staffplanning left join information as Regionu12 on staffplanning.Week = Regionu12.Lastweek where staffplanning.Region='" . $region . "' and Regionu12.Agare='" . $region . "' and Tested = '' and (Regionu12.Bklass = 'B2' or Regionu12.Bklass = 'B1') group by staffplanning.Week) 
			as RegionUntested12 on staffplanning.Week = RegionUntested12.Week";
}
else {
	$query="select distinct(staffplanning.Week) as week, staffplanning.Mondaydate as mondaydate, Totregion45, Totregion3, Totregion12, Testregion45, Testregion3, Testregion12, Untestregion45, Untestregion3, Untestregion12, 
			(IFNULL(Totregion45, 0) + IFNULL(Totregion3, 0) + IFNULL(Totregion12, 0)) as countTotal,
			(round((IFNULL(Totregion45, 0) + IFNULL(Totregion3, 0) + IFNULL(Totregion12, 0))*0.7)) as hoursTotal from staffplanning left join 
			
			(select Week, count(*) as Totregion from staffplanning left join information as Region on staffplanning.Week = Region.Lastweek group by staffplanning.Week) 
			as Region1 on staffplanning.Week = Region1.Week left join 


			(select Week, count as Totregion45 from staffplanning left join (select Lastweek, count(*) as count from information where Bklass = 'B5' or Bklass = 'B4' group by Lastweek) as Regiont45 on staffplanning.Week = Regiont45.Lastweek group by staffplanning.Week) 
			as RegionTot45 on staffplanning.Week = RegionTot45.Week left join
			(select Week, count as Totregion3 from staffplanning left join (select Lastweek, count(*) as count from information where Bklass = 'B3' group by Lastweek) as Regiont3 on staffplanning.Week = Regiont3.Lastweek group by staffplanning.Week) 
			as RegionTot3 on staffplanning.Week = RegionTot3.Week left join
			(select Week, count as Totregion12 from staffplanning left join (select Lastweek, count(*) as count from information where Bklass = 'B2' or Bklass = 'B1' group by Lastweek) as Regiont12 on staffplanning.Week = Regiont12.Lastweek group by staffplanning.Week) 
			as RegionTot12 on staffplanning.Week = RegionTot12.Week left join

			(select Week, count as Testregion45 from staffplanning left join (select Lastweek, count(*) as count from information where (Bklass = 'B5' or Bklass = 'B4') and Tested != '' group by Lastweek) as Regiontest45 on staffplanning.Week = Regiontest45.Lastweek group by staffplanning.Week) 
			as RegionTested45 on staffplanning.Week = RegionTested45.Week left join
			(select Week, count as Testregion3 from staffplanning left join (select Lastweek, count(*) as count from information where Bklass = 'B3' and Tested != '' group by Lastweek) as Regiontest3 on staffplanning.Week = Regiontest3.Lastweek group by staffplanning.Week) 
			as RegionTested3 on staffplanning.Week = RegionTested3.Week left join
			(select Week, count as Testregion12 from staffplanning left join (select Lastweek, count(*) as count from information where (Bklass = 'B2' or Bklass = 'B1') and Tested != '' group by Lastweek) as Regiontest12 on staffplanning.Week = Regiontest12.Lastweek group by staffplanning.Week) 
			as RegionTested12 on staffplanning.Week = RegionTested12.Week left join

			(select Week, count as Untestregion45 from staffplanning left join (select Lastweek, count(*) as count from information where (Bklass = 'B5' or Bklass = 'B4') and Tested = '' group by Lastweek) as Regionu45 on staffplanning.Week = Regionu45.Lastweek group by staffplanning.Week) 
			as RegionUntested45 on staffplanning.Week = RegionUntested45.Week left join
			(select Week, count as Untestregion3 from staffplanning left join (select Lastweek, count(*) as count from information where Bklass = 'B3' and Tested = '' group by Lastweek) as Regionu3 on staffplanning.Week = Regionu3.Lastweek group by staffplanning.Week) 
			as RegionUntested3 on staffplanning.Week = RegionUntested3.Week left join
			(select Week, count as Untestregion12 from staffplanning left join (select Lastweek, count(*) as count from information where (Bklass = 'B2' or Bklass = 'B1') and Tested = '' group by Lastweek) as Regionu12 on staffplanning.Week = Regionu12.Lastweek group by staffplanning.Week) 
			as RegionUntested12 on staffplanning.Week = RegionUntested12.Week";
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
