<?php 
require_once 'core/init.php';

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);
$week = $request->week;
$region = $request->region;
$time = $request->time;
$type = $request->type;

$db = DB::getInstance();
$query = "update staffplanning set " . $type . "=" . $time . " where Week=" . $week . " and Region='" . $region . "'";

$query = trim(iconv('utf-8', 'windows-1252', $query));

$db->query($query);
?>

