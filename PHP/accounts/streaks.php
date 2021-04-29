<?php
require("./dbconfig.php");
require("./requests.php");

$userID = $_POST["userID"];
$row = getStreak($userID, $pdo);
if ($row == "User not registered") {
    echo $row;
} else {
    echo $row["streak"];
}
?>