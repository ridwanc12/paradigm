<?php
/* Hides a journal entry given jourID - Jeremy Yang*/
require("./dbconfig.php");
require("./keys/keys.php");

// Get variables sent from application
$param_jourID = trim($_POST["jourID"]);


// Write out SQL query to be prepared
$sql = "UPDATE journals
        SET hidden = :hidden
        WHERE jourID = :jourID";

// Prepare SQL statement
if ($insert = $pdo->prepare($sql)) {
    $param_hidden = 0;
    // Bind variables to the prepared statement as parameters
    $insert->bindParam(":jourID", $param_jourID, PDO::PARAM_INT);
    $insert->bindParam(":hidden", $param_hidden, PDO::PARAM_INT);

    // Execute statement
    if ($insert->execute()) {
        echo "Journal unhid";
    } else {
        echo "Something is wrong";
    }
    // Clear $insert
    unset($insert);
}

// Disconnect from database
unset($pdo);
?>