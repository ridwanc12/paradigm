<?php
require("../dbconfig.php");

//Our SQL statement, which will select a list of tables from the current MySQL database.
$sql = "SHOW TABLES FROM id12866202_paradigm";

//Prepare our SQL statement,
$statement = $pdo->prepare($sql);

//Execute the statement.
$statement->execute();
$statement->setFetchMode(PDO::FETCH_ASSOC);

// Set up flag to see if table is in DB
$flag = 0;
//Fetch the rows from our statement.
while($tables = $statement->fetch()) {
    $name = trim($tables["Tables_in_id12866202_paradigm"]);
    $journals = "journals";

    // strcmp returns 0 if strings are equal
    if (!strcmp($name, $journals)) {
        echo "Table is in database.";
        $flag = 1;
        break;
    }
        
}

// If flag == 0, table is not in DB
if ($flag == 0) {
    echo "\"journals\" table was not created.";
}
unset($statement);
unset($pdo);

?>