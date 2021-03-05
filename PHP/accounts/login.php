<?php
require("./dbconfig.php");
$param_email = $param_password = "";

// Write SQL query to retrieve hashPass from table
$sql = "SELECT hashPass, userID, firstName, lastName, verified FROM accounts WHERE email = :email";
if ($stmt = $pdo->prepare($sql)) {
    // Bind variables to the prepared statement as parameters
    $stmt->bindParam(":email", $param_email, PDO::PARAM_STR);

    // Set parameters
    $param_email = trim($_POST["email"]);

    // Attempt to execute the prepared statement
    if ($stmt->execute()) {
        // If rowcount == 1, email is registered
        if ($stmt->rowCount() == 1) {
            // Set result to be associated with column name
            $stmt->setFetchMode(PDO::FETCH_ASSOC);
            // Fetch one row from query result
            $row = $stmt->fetch();
            if ((int)$row['verified'] == 0) {
                echo "Please verify your account first.";
                unset($stmt);
                unset($pdo);
                exit();
            }
            $hashed_password = $row['hashPass'];
            $userInfo = array("userID" => $row["userID"],
                               "firstName" => $row["firstName"],
                               "lastName" => $row["lastName"]);
            // Get user inputted password from application
            $param_password = trim($_POST["password"]);
            // Verify password give by the user against hashed password
            if(password_verify($param_password, $hashed_password)) {
                echo "Login successful";
                echo json_encode($userInfo);
            } else {
                echo "Incorrect password. Please try again.";
            }
            
        } else {
            // Email not registered
            echo "Email not registered.";
        }
    } else {
        echo "Oops! Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}

// Close connection with database
unset($pdo);
?>
