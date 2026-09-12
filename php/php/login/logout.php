<?php
/**
 * File: logout.php
 * Author: Cygnus J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 * Course: INFS 657: Data Design and Development - McGill University
 *
 * Description:
 * This is the logout command that limits exclusive access to specific web pages.
 *
 */
session_start();
session_unset();
session_destroy();
header("Location: login.php");
exit();