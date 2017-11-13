<?php 
require_once 'core/init.php';
$year = date('Y');
$firstDayOfYear = mktime(0, 0, 0, 1, 1, $year);
$nextMonday     = strtotime('monday', $firstDayOfYear);
$regions = ['Syd', 'Väst', 'Öst', 'Mitt', 'Nord'];

$db = DB::getInstance();

if(date('Y-m-d',strtotime($year . 'W01')) > date('Y-m-d', mktime(0, 0, 0, 1, 1, $year))) {
 	$week = date('W', strtotime($year . 'W01 - 1 week'));
 	$date = date('Y-m-d',strtotime($year . 'W01 - 1 week'));
 	foreach($regions as $region) {
 		$db->query("insert into staffplanning (Week, Mondaydate, Region) values(" . $week . ", '" . $date . "', '" . $region . "')");
 	}               
} else if (date('Y-m-d',strtotime($year . 'W01')) < date('Y-m-d', mktime(0, 0, 0, 1, 1, $year))) {
	$week = date('W', strtotime($year . 'W01'));
 	$date = date('Y-m-d',strtotime($year . 'W01'));
 	foreach($regions as $region) {
 		$db->query("insert into staffplanning (Week, Mondaydate, Region) values(" . $week . ", '" . $date . "', '" . $region . "')");
 	}
}

while (date('Y', $nextMonday) == $year) {
	$week = date('W', $nextMonday);
	$date = date('Y-m-d', $nextMonday);
	foreach($regions as $region) {
 		$db->query("insert into staffplanning (Week, Mondaydate, Region) values(" . $week . ", '" . $date . "', '" . $region . "')");
 	}
    $nextMonday = strtotime('+1 week', $nextMonday);
}



?>