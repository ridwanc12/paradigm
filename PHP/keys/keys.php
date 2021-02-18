<?php
require("hack.php");
/*****START ECRYPTION***********/
$mcrypt = mcrypt_module_open('rijndael-256', '', 'cbc', '');//Opens the module
$iv = base64_decode("7uFWfGvA1JI2Qr3bSA9rpQhORl4wq2Udjv3rL36gR4E=");//Define initialization vector
$key = md5("why can't we use sodium");//Generate key using md5 function. Output is 32 characters long string
 
?>