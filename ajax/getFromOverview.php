<?php
include('../includes/config.php');
$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

$region = $request->region;
$week = $request->week;
$tested = $request->tested;
$inspectionClass = $request->inspectionClass;

$query = "select * from information where Lastweek='" . $week . "' ";

if($region) {
	$query .= "and Agare = '" . $region . "' ";
}

if($tested == 0) {
	$query .= "and Tested = '' ";
} else if ($tested == 1) {
	$query .= "and Tested != '' ";
} 

if($inspectionClass == 45) {
	$query .= "and (Bklass = 'B5' or Bklass = 'B4') ";
} else if($inspectionClass == 3) {
	$query .= "and Bklass = 'B3' ";
} else if($inspectionClass == 12) {
	$query .= "and (Bklass = 'B2' or Bklass = 'B1') ";
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