<?php
include('../includes/config.php');

$query="select distinct(Bdl), Agare from information order by Bdl";
$result = $mysqli->query($query) or die($mysqli->error.__LINE__);

$arr = array();
if($result->num_rows > 0) {
	while($row = $result->fetch_assoc()) {
		$arr[] = $row;	
	}
}
array_walk_recursive($arr, function(&$value, $key) {
    if (is_string($value)) {
        $value = trim(iconv('windows-1252', 'utf-8', $value));
    }
});

# JSON-encode the response
$json_response = json_encode($arr);

// # Return the response
echo $json_response;
?>
