<?php
require("./dbconfig.php");

// Initialize parameters to use in SQL insertion
$param_userID = $param_entry = $param_sentiment = $param_rating = $param_topics = "";

// Get variables sent from application
$param_userID = trim($_POST["userID"]);
$param_entry = trim($_POST["entry"]);
$param_sentiment = trim($_POST["sentiment"]);
$param_rating = trim($_POST["rating"]);
$param_topics = trim($_POST["topics"]);

// Get current time in EST time zone.
$tz = 'America/New_York';
$tz_obj = new DateTimeZone($tz);
$today = new DateTime("now", $tz_obj);
$date = $today->format('Y-m-d H:i:s');
$param_created = $lastEdited = $date;

// Write out SQL query to be prepared
$sql = "INSERT INTO journals (userID, entry, created, sentScore, rating, lastEdited, topics) 
        VALUES (:userID, :entry, :created, :sentiment, :rating, :lastEdited, :topics)";

// Prepare SQL statement
if ($insert = $pdo->prepare($sql)) {

    // Bind variables to the prepared statement as parameters
    $insert->bindParam(":userID", $param_userID, PDO::PARAM_STR);
    $insert->bindParam(":entry", $param_entry, PDO::PARAM_STR);
    $insert->bindParam(":sentiment", $param_sentiment, PDO::PARAM_INT);
    $insert->bindParam(":rating", $param_rating, PDO::PARAM_INT);
    $insert->bindParam(":created", $param_created, PDO::PARAM_STR);
    $insert->bindParam(":lastEdited", $lastEdited, PDO::PARAM_STR);
    $insert->bindParam(":topics", $param_topics, PDO::PARAM_STR);

    // Execute statement
    if ($insert->execute()) {
        echo "Entry inserted";
    } else {
        echo "Something is wrong";
    }
    // Clear $insert
    unset($insert);
}

// Disconnect from database
unset($pdo);
?>