<?php
require("./dbconfig.php");
$param_email = $param_password = "";

// Write SQL query to retrieve hashPass from table
$sql = "SELECT hashPass, userID FROM accounts WHERE email = :email";
if ($stmt = $pdo->prepare($sql)) {
    // Bind variables to the prepared statement as parameters
    $stmt->bindParam(":email", $param_email, PDO::PARAM_STR);

    // Set parameters
    $param_email = trim($_POST["email"]);

    // Attempt to execute the prepared statement
    if ($stmt->execute()) {
        if ($stmt->rowCount() == 1) {
            // Set result to be associated with column name
            $stmt->setFetchMode(PDO::FETCH_ASSOC);
            // Fetch one row from query result
            $row = $stmt->fetch();
            $hashed_password = $row['hashPass'];
            $param_userID = $row['userID'];
            // Get user inputted password from application
            $param_password = trim($_POST["password"]);
            // Verify password give by the user against hashed password
            if(password_verify($param_password, $hashed_password)) {
                // Delete all journal entries of the user from journal
                $delete_journals = "DELETE FROM journals 
                                    WHERE userID = :userID";
                $delete = $pdo->prepare($delete_journals);
                $delete->bindParam(":userID", $param_userID, PDO::PARAM_INT);
                if ($delete->execute()) {
                    // Delete the user from accounts
                    unset($delete);
                    $delete_journals = "DELETE FROM accounts 
                                        WHERE userID = :userID";
                    $delete = $pdo->prepare($delete_journals);
                    $delete->bindParam(":userID", $param_userID, PDO::PARAM_INT);
                    if ($delete->execute()) {
                        unset($delete);
                        echo "User deleted.";
                    }
                } else {
                    unset($delete);
                    echo "Something was wrong.";
                }
            } else {
                echo "Incorrect password. Please try again.";
            }
        } else {
            // Email not registered
            echo "Email not registered.";
        }
    } else {
        echo "Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}

// Close connection with database
unset($pdo);
?>