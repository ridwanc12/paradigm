<?php
require("./dbconfig.php");
require("./keys/keys.php");

// Initialize parameters to use in SQL insertion
$param_userID = $param_entry = $param_sentiment = $param_rating = $param_topics = "";
$sql = "SELECT jourID, topics FROM journals";
$retrieve = $pdo->prepare($sql);
if ($retrieve->execute()) {
    // Set result to be associated with column name
    $retrieve->setFetchMode(PDO::FETCH_ASSOC);
    // Open mcrypt buffers to start encrypting journal topics
    // Fetch encrypted entry from result
    while ($row = $retrieve->fetch()) {
        
        $jourID = $row['jourID'];
        $topics = $row['topics'];
        if ($topics == "") {
            $topics = "Topics unavailiable";
        }
        $mcrypt = mcrypt_module_open('rijndael-256', '', 'cbc', '');//Opens the module
        mcrypt_generic_init($mcrypt, $key, $iv);
        $encrypted_topics = mcrypt_generic($mcrypt, $topics);//Encrypt user topic
        $encrypted_topics = base64_encode($encrypted_topics);// base_64 encode the encrypted entry
        // Remember to close mcrypt buffers and module
        mcrypt_generic_deinit($mcrypt);//Close buffers
        mcrypt_module_close($mcrypt);//Close MCrypt module
        // Write out SQL query to be prepared
        $sql = "UPDATE journals
        SET topics = :topics
        WHERE jourID = :jourID";

        // Prepare SQL statement
        if ($insert = $pdo->prepare($sql)) {
            // Bind variables to the prepared statement as parameters
            $insert->bindParam(":jourID", $jourID, PDO::PARAM_INT);
            $insert->bindParam(":topics", $encrypted_topics, PDO::PARAM_STR);
        }

        // Execute statement
        if ($insert->execute()) {
            echo "Entry edited";
        } else {
            echo "Something is wrong";
        }
        // Clear $insert
        unset($insert);
    }

}

unset($retrieve);
// Disconnect from database
unset($pdo);
?>