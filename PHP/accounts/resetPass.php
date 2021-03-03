<?php
/* Resets user password to a randomly generated string and email the new password
   to the user.
   */
require("./dbconfig.php");
$param_email = $param_newPass = $newPass = "";

// Write SQL query to retrieve hashPass from table
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
        echo "Password resetted";
        $to      = $param_email; // Send email to our user
        $subject = 'Your New Password'; // Give the email a subject 
        $message = '
A new password has been randomly generated for your account. Please login in with: ' . 
$newPass . ' and proceed to change your password.'; // Our message above including the new password

       $headers = 'From:noreply@paradigm.com' . "\r\n"; // Set from headers
       mail($to, $subject, $message, $headers); // Send our email

        
    } else {
        echo "Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}

// Close connection with database
unset($pdo);
?>