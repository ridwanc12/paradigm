<?php
require("./dbconfig.php");

// Initialize parameters to use in SQL insertion
$param_sentiment = "";

// Get variables sent from application
$param_jourID = trim($_POST["jourID"]);
$param_sentiment = trim($_POST["sentiment"]);
$param_sentScore = trim($_POST["sentScore"]);

// Get current time in EST time zone.
$timezone = 'America/New_York';
$timezone_obj = new DateTimeZone($timezone);
$today = new DateTime("now", $timezone_obj);
$date = $today->format('Y-m-d H:i:s');
$lastEdited = $date;

// Write out SQL query to be prepared
$sql = "UPDATE journals
        SET sentiment = :sentiment, sentScore = :sentScore, 
            lastEdited = :lastEdited
        WHERE jourID = :jourID";

// Prepare SQL statement
if ($insert = $pdo->prepare($sql)) {
    // Bind variables to the prepared statement as parameters
    $insert->bindParam(":sentiment", $param_sentiment, PDO::PARAM_STR);
    $insert->bindParam(":sentScore", $param_sentScore, PDO::PARAM_STR);
    $insert->bindParam(":lastEdited", $lastEdited, PDO::PARAM_STR);


    // Execute statement
    if ($insert->execute()) {
        echo "SentScore edited";
    } else {
        echo "Something is wrong";
    }
    // Clear $insert
    unset($insert);
}

// Disconnect from database
unset($pdo);
?>