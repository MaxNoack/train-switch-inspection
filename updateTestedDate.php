<?php 
require_once 'core/init.php';

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);
$id = $request->id;
$testDate = $request->testDate;
$dateOK = false;

function validateDate($date, $format = 'Y-m-d')
{
    $d = DateTime::createFromFormat($format, $date);
    return $d && $d->format($format) == $date;
}

if(validateDate($testDate, 'Y-m-d')) {
	$testWeek = date('W', strtotime($testDate));
	$dateOK = true;
	echo("OK");
}
else if($testDate == '') {
	$testDate = '';
	$testWeek = '';
	$dateOK = true;
	echo("OK");
} else {
	echo("INTE OK");
}

if($dateOK) {
	$db = DB::getInstance();
	$query = "update information set Tested='" . $testDate . "', Testedweek='" . $testWeek . "' where id=" . $id;

	$query = trim(iconv('utf-8', 'windows-1252', $query));

	$db->query($query);
}



?>

