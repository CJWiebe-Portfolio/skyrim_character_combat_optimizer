<?php
/**
 * =========================================================
 * FILE: home.php
 * PROJECT: Skyrim Character Combat Optimization System
 * AUTHOR: Cygnus J. Wiebe
 * DATE: April 2026
 * COURSE: INFS 657 - McGill University
 * =========================================================
 * DESCRIPTION:
 * Main dashboard landing page. Provides navigation to:
 * - Item browsing (weapons/armor)
 * - Character management (via session-based access)
 * - Reference of sources used in the project
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
$pageTitle = "Home - Skyrim Optimizer";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php require_once '../page_formatting/header.php'; ?>
<?php require_once '../page_formatting/navbar.php'; ?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- ===================== HTML BODY ===================== -->

<body>
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <!-- ===================== HEADER ===================== -->
                    <div class="text-center">
                        <h1 class="section-title title-main">Skyrim Character Combat Optimization</h1>
                        <p class="text-muted-custom">
                            Cygnus J. Wiebe | McGill University | April 2026<br>
                            INFS: 657 | Prof. Kartikay Chadha
                        </p>
                    </div>
                    <br>
                    <div class="skyrim-action-card">
                        <a href="<?= BASE_URL ?>/general_information/all_items.php" 
                            class="skyrim-btn skyrim-btn-info text-xl">
                            🛡️ View all Armours and Weapons ⚔️
                        </a>
                    </div>
                    <br>
                    <div class="skyrim-action-card">
                        <a href="<?= BASE_URL ?>/main/references.php" 
                            class="skyrim-btn skyrim-btn-info text-xl">
                            📚 References 📚
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