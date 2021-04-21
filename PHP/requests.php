<?php
/* Contains functions used by other scripts */
// Gets user based on userID
function getUser($userID, $pdo) {
    $param_userID = $userID;
    $sql = "SELECT hashPass, userID, firstName, lastName, verified FROM accounts WHERE userID = :userID";
    if ($stmt = $pdo->prepare($sql)) {
        // Bind variables to the prepared statement as parameters
        $stmt->bindParam(":userID", $param_userID, PDO::PARAM_STR);

        // Attempt to execute the prepared statement
        if ($stmt->execute()) {
        // If rowcount == 1, user is registered
            if ($stmt->rowCount() == 1) {
                // Set result to be associated with column name
                $stmt->setFetchMode(PDO::FETCH_ASSOC);
                // Fetch one row from query result
                $row = $stmt->fetch();
            } else {
                // Email not registered
             echo "User not registered.";
            }
        } else {
            echo "Oops! Something went wrong. Please try again later.";
        }

        // Close statement
        unset($stmt);
    }
    return $row;
}

function getStreak($userID, $pdo) {
    $param_userID = $userID;
    $sql = "SELECT streak, longest, inserted FROM streaks WHERE userID = :userID";
    if ($stmt = $pdo->prepare($sql)) {
        // Bind variables to the prepared statement as parameters
        $stmt->bindParam(":userID", $param_userID, PDO::PARAM_INT);

        // Attempt to execute the prepared statement
        if ($stmt->execute()) {
        // If rowcount == 1, user is registered
            if ($stmt->rowCount() == 1) {
                // Set result to be associated with column name
                $stmt->setFetchMode(PDO::FETCH_ASSOC);
                // Fetch one row from query result
                $row = $stmt->fetch();
            } else {
                // Email not registered
             return "User not registered.";
            }
        }

        // Close statement
        unset($stmt);
    }
    return $row;
}

?>