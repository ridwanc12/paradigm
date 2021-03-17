<?php
/* Resets user password to a randomly generated string and email the new password
   to the user.
   */
require("./dbconfig.php");
require "mail.php";
$param_email = $param_newPass = $newPass = "";

$sql = "SELECT firstName FROM accounts WHERE email = :email";
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
            $firstName = $row['firstName'];
        } else {
            unset($stmt);
            unset($pdo);
            exit("Email not registered.");
        }
    } else {
        echo "Oops! Something went wrong. Please try again later.";
    }
}

// Write SQL query to change hashPass from table
$sql = "UPDATE accounts SET hashPass = :hashPass WHERE email = :email";
if ($stmt = $pdo->prepare($sql)) {
    // Bind variables to the prepared statement as parameters
    $stmt->bindParam(":hashPass", $param_newPass, PDO::PARAM_STR);
    $stmt->bindParam(":email", $param_email, PDO::PARAM_STR);
    // Create random password
    $newPass = uniqid();
    $param_newPass = password_hash($newPass, PASSWORD_DEFAULT);

    $param_email = trim($_POST["email"]);
    // Attempt to execute the prepared statement
    if ($stmt->execute()) {
        // Send new password to user
        echo "Password resetted.";
        $to      = $param_email;
        $subject = 'Your New Password';
        $message = '
        A new password has been randomly generated for your account. Please login in with: ' . 
        $newPass . ' and proceed to change your password.'; 
        phpmail($to, $firstName, $subject, $message); // Send our email
    } else {
        echo "Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}

// Close connection with database
unset($pdo);
?>