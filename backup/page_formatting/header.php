<?php
/**
 * =========================================================
 * FILE: header.php
 * PROJECT: Skyrim Character Combat Optimization System
 * AUTHOR: C.J. Wiebe
 * DATE: April 2026
 * =========================================================
 * DESCRIPTION:
 * The general header for all pages.
 * =========================================================
 */
?>
<?php require_once '../main/config.php'; ?>

<head>

    <!-- ===================== PHP DOCTYPE ===================== -->
    <?php
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    ?>
    <!-- ===================== HTML DOCTYPE ===================== -->
    <!DOCTYPE HTML>
    <html lang="en">

    <!-- ===================== GENERAL PAGE TITLE ===================== -->
    <title><?= $pageTitle ?? 'Skyrim Optimizer' ?></title>

    <!-- ===================== FAVICON ===================== -->
    <link rel="icon" type="image/png" href="/skyrim_inventory_optimization/website/assets/images/skyrim_icon.png">

    <!-- ===================== CSS ===================== -->
    <!-- =========== BOOTSTRAP =========== -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- =========== GENERAL STYLES =========== -->
    <link rel="stylesheet" href="/skyrim_inventory_optimization/website/assets/css/general_style.css">

    <!-- =========== BACKGROUND =========== -->
    <link rel="stylesheet" href="/skyrim_inventory_optimization/website/assets/css/background_picture.css">
</head>