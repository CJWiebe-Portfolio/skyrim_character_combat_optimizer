<?php
/**
 * File: logout.php
 * Author: C.J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
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