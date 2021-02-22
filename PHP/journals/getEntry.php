<?php
require("./dbconfig.php");
require("./keys/keys.php");
$param_email = $param_password = "";

// Write SQL query to retrieve hashPass from table
$sql = "SELECT * FROM journals WHERE userID = :userID";
if ($stmt = $pdo->prepare($sql)) {
    // Bind variables to the prepared statement as parameters
    $userID = trim($_POST["userID"]);
    $stmt->bindParam(":userID", $userID, PDO::PARAM_INT);

    // Attempt to execute the prepared statement
    if ($stmt->execute()) {
        // Set result to be associated with column name
        $stmt->setFetchMode(PDO::FETCH_ASSOC);
        // Fetch encrypted entry from result
        $all_entries = array();
        while ($row = $stmt->fetch()) {
            $encrypted_entry = $row['entry'];
            // Open mcrypt module and buffer for decryption
            $mcrypt = mcrypt_module_open('rijndael-256', '', 'cbc', '');
            mcrypt_generic_init($mcrypt, $key, $iv);
            // Trim invisible padding characters from the decrypted entry
            $decrypted_entry = trim(mdecrypt_generic($mcrypt, base64_decode($encrypted_entry)), "\0\4");
            // Close mcrypt module and buffer
            mcrypt_generic_deinit($mcrypt);
            mcrypt_module_close($mcrypt);
            $jourID = $row['jourID'];
            $userID = $row['userID'];
            $created = $row['created'];
            $hidden = $row['hidden'];
            $sentScore = $row['sentScore'];
            $rating = $row['rating'];
            $lastEdited = $row['lastEdited'];
            $topics = $row['topics'];
            $all_entries[$created] = array("jourID" => $jourID,
                                           "userID" => $userID,
                                           "created" => $created,
                                           "hidden" => $hidden,
                                           "sentScore" => $sentScore,
                                           "rating" => $hidden,
                                           "lastEdited" => $lastEdited,
                                           "topics" => $topics); 
        }
        $json = json_encode($all_entries);
        echo $json;
    } else {
        echo "Oops! Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}

// Close connection with database
unset($pdo);
