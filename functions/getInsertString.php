<?php
$intervals = array(
	1 => 4,
	2 => 3,
	3 => 2,
	4 => 1,
	5 => 1);
$year1 = date('Y');
$year2 = date('Y', strtotime('+ 1 years'));
$year3 = date('Y', strtotime('+ 2 years'));
$year4 = date('Y', strtotime('+ 3 years'));
$yearArray = array($year1, $year2, $year3, $year4);

$years = array(
	$year1 => false,
	$year2 => false,
	$year3 => false,
	$year4 => false);
function getInsertString($rawData){
	global $years, $yearArray;
	$years = array_fill_keys($yearArray, false);
	$num = count($rawData);
	$date = $rawData[11];
	$inspectionClass = (int)substr($rawData[6], 1, 1);
	$nextDate = getNextDate($date, $inspectionClass);
	checkFourYears($nextDate, $inspectionClass);
	$lastDate = getLastDate($nextDate, $inspectionClass);
	$lastWeek = getLastWeek($lastDate);
	$returnString = "insert into information (Bdl, TplStr, Typ, UNE, Sparnr, Agare, Bklass, Mall, Benamning, Kmmfr, Kmmti, Recentdate, Nextdate, Lastdate, Lastweek, Year1, Year2, Year3, Year4, Tested) values (";
	for($i = 0; $i < $num - 1; $i++) {
		$returnString .= "'" . $rawData[$i] . "', ";
	}
	$returnString .= "'" . $rawData[$num - 1] . "', ";
	$returnString .= "'" . $nextDate . "', ";
	$returnString .= "'" . $lastDate . "', ";
	$returnString .= "'" . $lastWeek . "', ";
	foreach($years as $year => $value) {
		if($value == 1) {
			$returnString .= "true, ";
		}
		else {
			$returnString .= "false, ";
		}
	}
	$returnString .= " '');";
	return $returnString;
}
function getAddedDays($classification) {
	global $intervals;
	return 365*$intervals[$classification];
}
function getNextDate($date, $inspectionClass) {
	$returnDate = date("Y-m-d");
	$firstOfYear = date("Y-m-d", mktime(1, 1, 1, 1, 1, date('Y')));
	if(empty($date)) {
		if($inspectionClass < 3) {
			$returnDate = date("Y-m-d", mktime(1, 1, 1, 12, 31, date('Y', strtotime('+ 5 years'))));
		} else {
			$returnDate = $firstOfYear;
		}
	} else {
		$returnDate = date('Y-m-d', strtotime($date . ' + ' . getAddedDays($inspectionClass) . ' days'));
	}
	if($returnDate < $firstOfYear) {
		$returnDate = $firstOfYear;
	}	
	return $returnDate;
}
function getLastDate($nextDate, $inspectionClass) {
	global $year1, $year2, $years;
	if($years[$year1] == true) {
		if(date('Y-m-d', strtotime($nextDate. ' + 60 days')) > $year2) {
			return date("Y-m-d", mktime(1, 1, 1, 12, 31, date('Y')));
		}
	} 
	return date('Y-m-d', strtotime($nextDate. ' + 60 days'));
}
function getLastWeek($lastDate) {
	global $year2;
	if($lastDate < $year2) {
		if($lastDate > date("Y-m-d", mktime(1, 1, 1, 12, 27, date('Y'))) && date("W", strtotime($lastDate)) == 01) {
			return date("W", mktime(1, 1, 1, 12, 27, date('Y')));
		} else {
			return date("W", strtotime($lastDate));
		}
	}
	return 0;
}
function checkFourYears($nextDate, $inspectionClass) {
	global $years, $year4, $year1;
	$tests = 4;
	for($i = 0; $i < $tests; $i++) {
		$nextYear = date('Y', strtotime($nextDate. ' + ' . $i*getAddedDays($inspectionClass) . ' days'));
		if($nextYear < $year1) {
			$tests++;
		}
		else if($nextYear <= $year4) {
			$years[$nextYear] = true;
		}
	}
}
?>