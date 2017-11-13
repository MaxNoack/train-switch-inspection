<?php 
require_once 'core/init.php';

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);
$id = $request->id;
$plannedWeek = $request->plannedWeek;

$db = DB::getInstance();
$query = "update information set Plannedweek=" . $plannedWeek . " where id=" . $id;

$query = trim(iconv('utf-8', 'windows-1252', $query));

$db->query($query);
?>

