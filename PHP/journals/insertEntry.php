<?php
require("./dbconfig.php");
require("./keys/keys.php");

// Initialize parameters to use in SQL insertion
$param_userID = $param_entry = $param_sentiment = $param_rating = $param_topics = "";

// Get variables sent from application
$param_userID = trim($_POST["userID"]);
$param_entry = trim($_POST["entry"]);
$param_sentiment = trim($_POST["sentiment"]);
$param_sentScore = trim($_POST["sentScore"]);
$param_rating = trim($_POST["rating"]);
$param_topics = trim($_POST["topics"]);

// Get current time in EST time zone.
$tz = 'America/New_York';
$tz_obj = new DateTimeZone($tz);
$today = new DateTime("now", $tz_obj);
$date = $today->format('Y-m-d H:i:s');
$param_created = $lastEdited = $date;

// Write out SQL query to be prepared
$sql = "INSERT INTO journals (userID, entry, created, sentiment, sentScore, rating, lastEdited, topics) 
        VALUES (:userID, :entry, :created, :sentiment, :sentScore, :rating, :lastEdited, :topics)";

// Prepare SQL statement
if ($insert = $pdo->prepare($sql)) {

    // Open mcrypt buffers to start encrypting journal entry
    mcrypt_generic_init($mcrypt, $key, $iv);//Open buffers
    $encrypted_entry = mcrypt_generic($mcrypt, $param_entry);//Encrypt user journal
    $encrypted_entry = base64_encode($encrypted_entry);// base_64 encode the encrypted entry
    // Remember to close mcrypt buffers and module
    mcrypt_generic_deinit($mcrypt);//Close buffers
    mcrypt_module_close($mcrypt);//Close MCrypt module

    // Bind variables to the prepared statement as parameters
    $insert->bindParam(":userID", $param_userID, PDO::PARAM_STR);
    $insert->bindParam(":entry", $encrypted_entry, PDO::PARAM_STR);
    $insert->bindParam(":sentiment", $param_sentiment, PDO::PARAM_STR);
    $insert->bindParam(":sentScore", $param_sentScore, PDO::PARAM_STR);
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

$sql = "UPDATE accounts 
        SET lastEntry = :lastEntry 
        WHERE userID = :userID";
if ($update = $pdo->prepare($sql)) {
    // Bind variables to the prepared statement as parameters
    $update->bindParam(":userID", $param_userID, PDO::PARAM_STR);
    $update->bindParam(":lastEntry", $param_created, PDO::PARAM_STR);

    // Execute statement
    if ($update->execute()) {
        echo "Last entry time updated";
    } else {
        echo "Something is wrong";
    }
    // Clear $insert
    unset($update);
}

// Disconnect from database
unset($pdo);
?>