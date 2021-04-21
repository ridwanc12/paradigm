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
        echo $stmt->rowCount();
    } else {
        echo "Oops! Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}

// Close connection with database
unset($pdo);
?>