<?php

/**
 * =========================================================
 * FILE: success.php
 * PROJECT: Skyrim Character Combat Optimization System
 * AUTHOR: Cygnus J. Wiebe
 * DATE: April 2026
 * COURSE: INFS 657 - McGill University
 * =========================================================
 * DESCRIPTION:
 * The page displays if the account had been created successfully
 * =========================================================
 */
?>

<!-- ============================================================================================ -->
<!-- ====================================== PHP STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- ===================== ACTIVE SESSION & PAGE TITLE ===================== -->
<?php
session_start();
include '../main/database.php';
$pageTitle = "Account Created Successfully";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php require_once '../page_formatting/header.php'; ?>
<?php require_once '../page_formatting/navbar.php'; ?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- ===================== HTML BODY ===================== -->

<body>
    <!-- This is the main content container to tell the user that their account has been created successfully -->
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <!-- ===================== PAGE TITLE ===================== -->
                    <div class="section-title">
                        <h1>Account Created Successfully</h1>
                        <p>The new user account has been added to the system.</p>
                        <!-- ===================== ACTION BUTTONS ===================== -->
                        <a href="<?= BASE_URL ?>/main/home.php" class="btn btn-primary">
                            Back to Home
                        </a>
                        <a href="<?= BASE_URL ?>/login/login.php" class="btn btn-primary">
                            Login
                        </a>
                    </div>
                </div>
            </div>
        </div>
</div>

    <!-- ===================== SCRIPTS ===================== -->
    <?php require_once '../page_formatting/scripts.php'; ?>
</body>
<!-- ===================== FOOTER ===================== -->
<?php require_once '../page_formatting/footer.php'; ?>


</html>