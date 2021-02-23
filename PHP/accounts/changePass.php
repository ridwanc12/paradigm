<?php
require("./dbconfig.php");
$param_email = $param_newPass = $param_oldPass = "";

// Write SQL query to retrieve hashPass from table
$sql = "SELECT hashPass FROM accounts WHERE email = :email";
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
            // Get user inputted password from application
            $param_oldPass = trim($_POST["oldPass"]);
            // Verify password give by the user against hashed password
            if(password_verify($param_oldPass, $hashed_password)) {
                $change_pass = "UPDATE accounts 
                                SET hashPass = :hashPass
                                WHERE email = :email";
                $param_newPass = trim($_POST["newPass"]);
                $update = $pdo->prepare($change_pass);
                $param_newPass = password_hash($param_newPass, PASSWORD_DEFAULT); // Creates a password hash
                $update->bindParam(":hashPass", $param_newPass, PDO::PARAM_STR);
                $update->bindParam(":email", $param_email, PDO::PARAM_STR);
                if ($update->execute()) {
                    echo "Password changed.";
                } else {
                    unset($update);
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