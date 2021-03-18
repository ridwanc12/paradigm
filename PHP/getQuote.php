<?php
require("./dbconfig.php");
$param_email = $param_password = "";

// Write SQL query to retrieve hashPass from table
$qID = rand(1,12);
$sql = "SELECT * FROM quotes WHERE qID = :qID";
if ($stmt = $pdo->prepare($sql)) {
    // Bind variables to the prepared statement as parameters
    $stmt->bindParam(":qID", $qID, PDO::PARAM_INT);

    // Attempt to execute the prepared statement
    if ($stmt->execute()) {
        // Set result to be associated with column name
        $stmt->setFetchMode(PDO::FETCH_ASSOC);
        // Fetch quote from result
        $row = $stmt->fetch();
        $quote = $row['quote'];
        $author = $row['author'];
        echo $quote . ' ' . $author;
    } else {
        echo "Oops! Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}

// Close connection with database
unset($pdo);
