<?php

/**
 * File: database.php
 * Author: C.J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 *
 * Description:
 * Establishes a connection to the database.
 * It uses PDO (PHP Data Objects) to connect to a MySQL database with the specified server, username, password, and database name.
 * If the connection fails, it catches the PDOException and displays an error message.
 * 
 */

$server = 'localhost'; // change if your server is remote
$username = 'web_access'; // Enter your username
$password = 'your_password_here'; // Enter your password
$database = 'skyrim_combat-optimization'; // Enter your database name you want to access

try { // Try the following code
    $conn = new PDO("mysql:host=$server;dbname=$database;", $username, $password);
} catch (PDOException $e) { //If try doesn't work, run the code in catch
    die("Connection failed: " . $e->getMessage());
}
