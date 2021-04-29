<?php
require("./dbconfig.php");
$sql = "SELECT * FROM streaks";
if ($stmt = $pdo->prepare($sql)) {
    
    if ($stmt->execute()) {
        // Set result to be associated with column name
        $stmt->setFetchMode(PDO::FETCH_ASSOC);
        // Fetch encrypted entry from result
        while ($row = $stmt->fetch()) {
            if ($row['inserted'] == 0) {
                $breakStreak = "UPDATE streaks
                                SET streak = 0
                                WHERE userID = :paramID";
                
                $break = $pdo->prepare($breakStreak);
                $break->bindParam(":paramID", $row['userID'], PDO::PARAM_INT);
                $break->execute();
            }
        }
        unset($break);
        $sql = "UPDATE streaks SET inserted = 0";
        $reset = $pdo->prepare($sql);
        $reset->execute();
    } else {
        echo "Oops! Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}

// Close connection with database
unset($pdo);
?>