<?php
require("./dbconfig.php");
require("./keys/keys.php");
$param_email = $param_password = "";

// Write SQL query to retrieve hashPass from table
$sql = "SELECT entry FROM journals WHERE jourID = :jID";
if ($stmt = $pdo->prepare($sql)) {
    // Bind variables to the prepared statement as parameters
    $id = trim($_POST["jID"]);
    $stmt->bindParam(":jID", $id, PDO::PARAM_INT);

    // Attempt to execute the prepared statement
    if ($stmt->execute()) {
        // If rowcount == 1, email is already registered
        if ($stmt->rowCount() == 1) {
            // Set result to be associated with column name
            $stmt->setFetchMode(PDO::FETCH_ASSOC);
            // Fetch encrypted entry from result
            $row = $stmt->fetch();
            $encrypted_entry = $row['entry'];
            // Open mcrypt module and buffer for decryption
            $mcrypt = mcrypt_module_open('rijndael-256', '', 'cbc', '');
            mcrypt_generic_init($mcrypt, $key, $iv);
            // Trim invisible padding characters from the decrypted entry
            $decrypted_entry = trim(mdecrypt_generic($mcrypt, base64_decode($encrypted_entry)), "\0\4");
            echo $decrypted_entry;
            mcrypt_generic_deinit($mcrypt);
            mcrypt_module_close($mcrypt);
            
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