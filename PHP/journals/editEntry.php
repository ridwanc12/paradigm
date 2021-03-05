<?php
require("./dbconfig.php");
require("./keys/keys.php");

// Initialize parameters to use in SQL insertion
$param_userID = $param_entry = $param_sentiment = $param_rating = $param_topics = "";

// Get variables sent from application
$param_jourID = trim($_POST["jourID"]);
$param_entry = trim($_POST["entry"]);
$param_sentiment = trim($_POST["sentiment"]);
$param_sentScore = trim($_POST["sentScore"]);
$param_hidden = trim($_POST["hidden"]);
$param_rating = trim($_POST["rating"]);
$param_topics = trim($_POST["topics"]);
$param_positive = trim($_POST["positive"]);
$param_negative = trim($_POST["negative"]);
$param_mixed = trim($_POST["mixed"]);
$param_neutral = trim($_POST["neutral"]);

// Get current time in EST time zone.
$timezone = 'America/New_York';
$timezone_obj = new DateTimeZone($timezone);
$today = new DateTime("now", $timezone_obj);
$date = $today->format('Y-m-d H:i:s');
$lastEdited = $date;

// Write out SQL query to be prepared
$sql = "UPDATE journals
        SET entry = :entry, sentiment = :sentiment, sentScore = :sentScore,  rating = :rating, 
        lastEdited = :lastEdited, topics = :topics, hidden = :hidden, positive = :positive,
        negative = :negative, mixed = :mixed, neutral = :neutral
        WHERE jourID = :jourID";

// Prepare SQL statement
if ($insert = $pdo->prepare($sql)) {

    // Open mcrypt buffer to start encrypting journal entry
    mcrypt_generic_init($mcrypt, $key, $iv);//Open buffers
    $encrypted_entry = mcrypt_generic($mcrypt, $param_entry);//Encrypt user journal
    $encrypted_entry = base64_encode($encrypted_entry);// base_64 encode the encrypted entry
    // Remember to close mcrypt buffers and module
    mcrypt_generic_deinit($mcrypt);
    mcrypt_module_close($mcrypt);

    // Bind variables to the prepared statement as parameters
    $insert->bindParam(":jourID", $param_jourID, PDO::PARAM_INT);
    $insert->bindParam(":entry", $encrypted_entry, PDO::PARAM_STR);
    $insert->bindParam(":sentiment", $param_sentiment, PDO::PARAM_STR);
    $insert->bindParam(":sentScore", $param_sentScore, PDO::PARAM_STR);
    $insert->bindParam(":hidden", $param_hidden, PDO::PARAM_INT);
    $insert->bindParam(":rating", $param_rating, PDO::PARAM_INT);
    $insert->bindParam(":lastEdited", $lastEdited, PDO::PARAM_STR);
    $insert->bindParam(":topics", $param_topics, PDO::PARAM_STR);
    $insert->bindParam(":positive", $param_positive, PDO::PARAM_STR);
    $insert->bindParam(":negative", $param_negative, PDO::PARAM_STR);
    $insert->bindParam(":mixed", $param_mixed, PDO::PARAM_STR);
    $insert->bindParam(":neutral", $param_neutral, PDO::PARAM_STR);


    // Execute statement
    if ($insert->execute()) {
        echo "Entry edited";
    } else {
        echo "Something is wrong";
    }
    // Clear $insert
    unset($insert);
}

// Disconnect from database
unset($pdo);
?>