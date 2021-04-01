<?php
// Include config file
require_once "./dbconfig.php";
require "./mail.php";

// Define variables and initialize with empty values
$email = $firstName = $lastName = $userID = $param_userID = "";
$email_err = "";

// Check if email is already registered
if (empty(trim($_POST["userID"]))) {
    unset($pdo);
    exit("Please provide a userID.");
} else {
    // Prepare a select statement
    $sql = "SELECT userID, email FROM accounts WHERE userID = :userID";
    if ($stmt = $pdo->prepare($sql)) {
        // Bind variables to the prepared statement as parameters
        $stmt->bindParam(":userID", $param_userID, PDO::PARAM_INT);

        // Set parameters
        $param_userID = trim($_POST["userID"]);

        // Attempt to execute the prepared statement
        if ($stmt->execute()) {
            // If rowcount == 1, email is in database
            if ($stmt->rowCount() == 1) {
                $stmt->setFetchMode(PDO::FETCH_ASSOC);
                $result = $stmt->fetch();
                $original_email = $result['email'];
                $userID = $result['userID'];
            } else {
                echo "No such user in database.";
                unset($stmt);
                unset($pdo);
                exit();
            }
        } else {
            echo "Something went wrong.";
        }
        // Close statement
        unset($stmt);
    }

    // Check if desired new email is already registered
    $sql = "SELECT email FROM accounts WHERE email = :email AND userID <> :userID";
    if ($stmt = $pdo->prepare($sql)) {
        // Bind variables to the prepared statement as parameters
        $stmt->bindParam(":email", $param_email, PDO::PARAM_STR);
        $stmt->bindParam(":userID", $param_userID, PDO::PARAM_INT);
        // Set parameters
        $param_email = trim($_POST["email"]);
        // Attempt to execute the prepared statement
        if ($stmt->execute()) {
            // Exit if desired email is already in database
            if ($stmt->rowCount() == 1) {
                unset($stmt);
                unset($pdo);
                exit("Email already registered.");
            }
        } else {
            echo "Something went wrong.";
        }
        // Close statement
        unset($stmt);
    }
}

// Get email
$email = trim($_POST["email"]);
// Prepare an UPDATE statement
$sql = "UPDATE accounts 
        SET email = :email, firstName = :first, lastName = :last
        WHERE userID = :userID";

if ($stmt = $pdo->prepare($sql)) {

    // Bind variables to the prepared statement as parameters
    $stmt->bindParam(":email", $param_email, PDO::PARAM_STR);
    $stmt->bindParam(":first", $firstName, PDO::PARAM_STR);
    $stmt->bindParam(":last", $lastName, PDO::PARAM_STR);
    $stmt->bindParam(":userID", $param_userID, PDO::PARAM_INT);
    // Set parameters
    $param_email = $email;
    $firstName = trim($_POST["firstName"]);
    $lastName = trim($_POST["lastName"]);

    // Attempt to execute the prepared statement
    if ($stmt->execute()) {
        echo "account edited.";
        // Send email to new email address if different from original email address
        if (!($email == $original_email)) {
            $to      = $email; // Send email to our user
            $subject = 'New email'; // Give the email a subject 
            $message = '
            Your email has been changed, you can login with your new email, ' . $email . ', now.';
            phpmail($original_email, $firstName, $subject, $message); // Send our email
            phpmail($to, $firstName, $subject, $message); // Send our email
        }
    } else {
        echo "Something went wrong.";
    }

    // Close statement
    unset($stmt);
}


// Close connection
unset($pdo);
