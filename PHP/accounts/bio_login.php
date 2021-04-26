<?php
require("./dbconfig.php");
$param_email = $param_password = "";

// Write SQL query to retrieve hashPass from table
$sql = "SELECT userID, firstName, lastName, verified FROM accounts WHERE email = :email";
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
            $userInfo = array("userID" => $row["userID"],
                           "firstName" => $row["firstName"],
                           "lastName" => $row["lastName"]);
            echo "Login successful ";
            echo json_encode($userInfo);
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
