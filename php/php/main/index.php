<?php

/**
 * =========================================================
 * FILE: index.php
 * PROJECT: Skyrim Character Combat Optimization System
 * AUTHOR: Cygnus J. Wiebe
 * DATE: April 2026
 * COURSE: INFS 657 - McGill University
 * =========================================================
 * DESCRIPTION:
 * This is the landing page of the website. It displays a welcome message and a logo, and then automatically redirects the user to the home page after a short delay.
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
$pageTitle = "Title - Skyrim Optimizer";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php require_once '../page_formatting/header.php'; ?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- ===================== HTML BODY ===================== -->
<body>
    <!--The main content of the page is wrapped in a flex container that centers the content both vertically and horizontally. -->
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5 mx-auto text-center">
                    <!-- The page displays a logo image, a main title "Skyrim Optimizer", and a subtitle "Preparing your adventure..."-->
                    <img src="<?= BASE_URL ?>/assets/images/skyrim_icon.png"
                        class="skyrim-title-logo text-center"
                        alt="Skyrim Logo">

                    <h1 class="skyrim-title-main">
                        Skyrim Optimizer
                    </h1>

                    <div class="skyrim-title-sub">
                        Preparing your adventure...
                    </div>

                    <a href="<?= BASE_URL ?>/main/home.php"
                        class="btn-skyrim-sm primary mt-3">
                        Skip →
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Smooth redirect -->
    <script>
        setTimeout(() => {
            document.body.style.transition = "opacity 0.5s ease";
            document.body.style.opacity = 0;
        }, 2500);
        setTimeout(() => {
            window.location.href = "../main/home.php";
        }, 3000);
    </script>

</body>
</html>