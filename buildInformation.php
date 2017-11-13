<?php 
require_once 'core/init.php';
include 'functions/getInsertString.php';
ini_set('max_execution_time', 300);
$time_start = microtime(true);
  $db = DB::getInstance();
  $row = 1;
  if (($handle = fopen("files/databas.csv", "r")) !== FALSE) {
    while (($data = fgetcsv($handle, 1000, ";")) !== FALSE) {
        if($row != 1) { 
          $db->query(getInsertString($data));
        }
        $row++;
    }
    fclose($handle);
  }
  $time_end = microtime(true);
  $execution_time = ($time_end - $time_start);
  $row = $row - 2;
  echo $row . " rader uppdaterade. Exekveringen tog " . round($execution_time, 1) ." sekunder."
?>