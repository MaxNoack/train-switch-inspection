<?php
include('../includes/config.php');
$postdata = file_get_contents("php://input");
$request = json_decode($postdata);
$region = "";
if($request) {
	$region = $request->region;
	$region = trim(iconv('utf-8', 'windows-1252', $region));
}

if($region) {
	$query="select * from staffplanning where Region = '" . $region . "'";
} else {
	$query="select * from staffplanning";
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