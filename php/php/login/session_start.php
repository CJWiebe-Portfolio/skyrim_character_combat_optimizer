<?php

/**
 * File: session_start.php
 * Author: Cygnus J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 * Course: INFS 657: Data Design and Development - McGill University
 *
 * Description:
 * This checks if login=true and determines if Admin or user.
 *
 */

session_start();
if (!isset($_SESSION['user_id'])) {
    header("Location: ../login/login.php");
    exit();
}

// Restrict if user is not admin:
if ($_SESSION['role'] !== 'admin') {
    echo "Access denied! Only admins can view this page.";
    exit();
}
