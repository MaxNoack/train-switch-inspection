<?php
include('../includes/config.php');

$nextYear = date('Y', strtotime('+ 1 year'));

$query="select * from information where Lastdate < '" . $nextYear . "-01-01' and Tested = 0 order by Bklass desc, Lastweek";

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
