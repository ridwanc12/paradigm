<?php
require("./dbconfig.php");
require("./keys/keys.php");
require("./requests.php");

// Initialize parameters to use in SQL insertion
$param_userID = $param_entry = $param_sentiment = $param_rating = $param_topics = "";

// Get variables sent from application
$param_userID = trim($_POST["userID"]);
$param_entry = trim($_POST["entry"]);
$param_sentiment = trim($_POST["sentiment"]);
$param_sentScore = trim($_POST["sentScore"]);
$param_rating = trim($_POST["rating"]);
$param_topics = trim($_POST["topics"]);
if ($param_topics == "") {
    echo "topics is empty";
    $param_topics = "Topics unavailiable";
}
$param_positive = trim($_POST["positive"]);
$param_negative = trim($_POST["negative"]);
$param_mixed = trim($_POST["mixed"]);
$param_neutral = trim($_POST["neutral"]);

// Get current time in EST time zone.
$tz = 'America/New_York';
$tz_obj = new DateTimeZone($tz);
$today = new DateTime("now", $tz_obj);
$date = $today->format('Y-m-d H:i:s');
$param_created = $lastEdited = $date;

$user = getUser($param_userID, $pdo);
if (!$user["verified"]) {
    unset($pdo);
    exit("Not verified");
}

// Write out SQL query to be prepared
$sql = "INSERT INTO journals (userID, entry, created, sentiment, sentScore, rating, lastEdited, topics, positive, negative, mixed, neutral) 
        VALUES (:userID, :entry, :created, :sentiment, :sentScore, :rating, :lastEdited, :topics, :positive, :negative, :mixed, :neutral)";

// Prepare SQL statement
if ($insert = $pdo->prepare($sql)) {

    // Open mcrypt buffers to start encrypting journal entry
    mcrypt_generic_init($mcrypt, $key, $iv);//Open buffers
    $encrypted_entry = mcrypt_generic($mcrypt, $param_entry);//Encrypt user journal
    $encrypted_entry = base64_encode($encrypted_entry);// base_64 encode the encrypted entry
    // Remember to close mcrypt buffers and module
    mcrypt_generic_deinit($mcrypt);//Close buffers
    mcrypt_module_close($mcrypt);//Close MCrypt module

    $mcrypt = mcrypt_module_open('rijndael-256', '', 'cbc', '');//Opens the module
    mcrypt_generic_init($mcrypt, $key, $iv);//Open buffers
    $encrypted_topics = mcrypt_generic($mcrypt, $param_topics);//Encrypt user journal
    $encrypted_topics = base64_encode($encrypted_topics);// base_64 encode the encrypted entry
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
    $insert->bindParam(":topics", $encrypted_topics, PDO::PARAM_STR);
    $insert->bindParam(":positive", $param_positive, PDO::PARAM_STR);
    $insert->bindParam(":negative", $param_negative, PDO::PARAM_STR);
    $insert->bindParam(":mixed", $param_mixed, PDO::PARAM_STR);
    $insert->bindParam(":neutral", $param_neutral, PDO::PARAM_STR);


    // Execute statement
    if ($insert->execute()) {
        echo "Entry inserted.";
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
    if (!($update->execute())) {
        echo "Something is wrong";
    }
    // Clear $insert
    unset($update);
}

$row = getStreak($param_userID, $pdo);
if ($row["inserted"] == 0) {
    $row["inserted"] = 1;
    $row["streak"]++;
    $sql = "UPDATE streaks 
            SET streak = :param_streak,
                longest = :param_longest,
                inserted = :inserted
            WHERE userID = :userID";
    if ($row["streak"] > $row["longest"]) {
        $row["longest"] = $row["streak"];
    }
    $update = $pdo->prepare($sql);
    $update->bindParam(":userID", $param_userID, PDO::PARAM_INT);
    $update->bindParam(":param_streak", $row["streak"], PDO::PARAM_STR);
    $update->bindParam(":param_longest", $row["longest"], PDO::PARAM_STR);
    $update->bindParam(":inserted", $row["inserted"], PDO::PARAM_STR);
    $update->execute();
    unset($update);
}
// Disconnect from database
unset($pdo);

?>