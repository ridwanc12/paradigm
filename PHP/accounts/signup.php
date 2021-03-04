<?php
// Include config file
require_once "./dbconfig.php";

// Define variables and initialize with empty values
$email = $password = $confirm_password = $firstName = $lastName = "";
$email_err = "";

// Check if email is already registered
if (empty(trim($_POST["email"]))) {
    $email_err = "";
} else {
    // Prepare a select statement
    $sql = "SELECT email FROM accounts WHERE email = :email";

    if ($stmt = $pdo->prepare($sql)) {
        // Bind variables to the prepared statement as parameters
        $stmt->bindParam(":email", $param_email, PDO::PARAM_STR);

        // Set parameters
        $param_email = trim($_POST["email"]);

        // Attempt to execute the prepared statement
        if ($stmt->execute()) {
            // If rowcount == 1, email is already registered
            if ($stmt->rowCount() == 1) {
                $email_err = "This email is already registered.";
                echo $email_err;
                unset($stmt);
                unset($pdo);
                exit();
            } else {
                $email = trim($_POST["email"]);
            }
        } else {
            echo "Something went wrong.";
        }

        // Close statement
        unset($stmt);
    }
}

// Get password
$password = trim($_POST["password"]);

// Prepare an insert statement
$sql = "INSERT INTO accounts (email, hashPass, firstName, lastName, lastEntry, verifyHash, verified) VALUES (:email, :password, :first, :last, null, :hash, :verified)";

if ($stmt = $pdo->prepare($sql)) {

    // Generate hashed string for email verification
    $hash = md5(rand(0,1000));

    // Bind variables to the prepared statement as parameters
    $stmt->bindParam(":email", $param_email, PDO::PARAM_STR);
    $stmt->bindParam(":password", $param_password, PDO::PARAM_STR);
    $stmt->bindParam(":first", $firstName, PDO::PARAM_STR);
    $stmt->bindParam(":last", $lastName, PDO::PARAM_STR);
    $stmt->bindParam(":hash", $hash, PDO::PARAM_STR);
    $stmt->bindParam(":verified", $param_verified, PDO::PARAM_INT);
    // Set parameters
    $param_verified = 0;
    $param_email = $email;
    $param_password = password_hash($password, PASSWORD_DEFAULT); // Creates a password hash
    $firstName = trim($_POST["firstName"]);
    $lastName = trim($_POST["lastName"]);

    // Attempt to execute the prepared statement
    if ($stmt->execute()) {
        // Redirect to login page
        echo "account created";
        $to      = $email; // Send email to our user
        $subject = 'Signup | Verification'; // Give the email a subject 
        $message = '
        Thanks for signing up!
        Your account has been created, you can login with the following credentials after you have activated your account by pressing the url below.
  
        Please click this link to activate your account:
        https<z>://boilerbite.000webhostapp</z>.com/paradigm/verify.php?email=' . $email . '&hash=' . $hash . '
  
        '; // Our message above including the link

        $headers = 'From:noreply@yourwebsite.com' . "\r\n"; // Set from headers
        mail($to, $subject, $message, $headers); // Send our email

        $sql = "SELECT userID FROM accounts WHERE email = :email";

        if ($stmt = $pdo->prepare($sql)) {
            // Bind variables to the prepared statement as parameters
            $stmt->bindParam(":email", $param_email, PDO::PARAM_STR);
    
            // Set parameters
            $param_email = trim($_POST["email"]);
    
            // Attempt to execute the prepared statement
            if ($stmt->execute()) {
                // If rowcount == 1, email is already registered
                if ($stmt->rowCount() == 1) {
                   $stmt->setFetchMode(PDO::FETCH_ASSOC);
                   $row = $stmt->fetch();
                   $userID = $row["userID"];
                   echo "\n" . $userID;
                } else {
                    echo "Something went wrong trying to retreive userID.";
                }
            } else {
                echo "Something went wrong.";
            }
    
            // Close statement
            unset($stmt);
        }
    } else {
        echo "Something went wrong.";
    }

    // Close statement
    unset($stmt);
}


// Close connection
unset($pdo);
