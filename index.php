<?php
$serverName = "sqlserver";
$connectionOptions = [
    "Database" => "master",
    "Uid" => "sa",
    "PWD" => "YourStrong!Passw0rd"
];

$conn = sqlsrv_connect($serverName, $connectionOptions);

if ($conn) {
    echo "Connected to SQL Server!";
} else {
    echo "Connection failed.";
    die(print_r(sqlsrv_errors(), true));
}
