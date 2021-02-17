<?php
require("./dbconfig.php");
if(isset($_GET['email']) && !empty($_GET['email']) AND isset($_GET['hash']) && !empty($_GET['hash'])){
    // Verify data
    $param_email = $_GET['email']; // Set email variable
    $param_hash = $_GET['hash']; // Set hash variable
    $sql = "SELECT email, verifyHash, verified 
            FROM accounts 
            WHERE email = :email
            AND verifyHash = :hash
            AND verified = '0'";

    if ($stmt = $pdo->prepare($sql)) {
        // Bind variables to the prepared statement as parameters
        $stmt->bindParam(":email", $param_email, PDO::PARAM_STR);
        $stmt->bindParam(":hash", $param_hash, PDO::PARAM_STR);

        // Attempt to execute the prepared statement
        if ($stmt->execute()) {
            // If rowcount == 1, verfiy account by changing verfied to 1
            if ($stmt->rowCount() == 1) {
                $verified = 1;
                $sql = "UPDATE accounts SET verified = :verified
                        WHERE email = :email";
                if ($update = $pdo->prepare($sql)) {
                    $update->bindParam(":email", $param_email, PDO::PARAM_STR);
                    $update->bindParam(":verified", $verified, PDO::PARAM_INT);
                    if ($update->execute()) {
                        echo "Account verified.";
                    }
                }
            } else {
                echo "Invalid URL or account already verified.";
            }
        } else {
            echo "Oops! Something went wrong. Please try again later.";
        }

        // Close statement
        unset($update);
        unset($stmt);
    }
                  
}else{
    // Invalid approach
    echo '<div class="statusmsg">Invalid approach, please use the link that has been send to your email.</div>';
}
?>