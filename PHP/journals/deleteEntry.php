<?php
require("./dbconfig.php");
$param_jourID = "";

// Write SQL query to retrieve hashPass from table
$sql = "DELETE FROM journals
        WHERE jourID = :jourID";
if ($stmt = $pdo->prepare($sql)) {
    // Bind variables to the prepared statement as parameters
    $stmt->bindParam(":jourID", $param_jourID, PDO::PARAM_INT);

    // Set parameters
    $param_jourID = trim($_POST["jourID"]);

    // Attempt to execute the prepared statement
    if ($stmt->execute()) {
        echo "Entry deleted.";
    } else {
        echo "Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}

// Close connection with database
unset($pdo);
?>