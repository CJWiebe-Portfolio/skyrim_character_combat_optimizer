<?php
/**
 * =========================================================
 * FILE: footer.php
 * PROJECT: Skyrim Character Combat Optimization System
 * AUTHOR: Cygnus J. Wiebe
 * DATE: April 2026
 * COURSE: INFS 657 - McGill University
 * =========================================================
 * DESCRIPTION:
 * The general footer for all pages.
 * =========================================================
 */
?>

<footer class="site-footer mt-auto py-4">
    <div class="container">

        <div class="row text-center text-md-start">

            <!-- Left -->
            <div class="col-md-4 mb-3">
                <h5 class="fw-bold text-lg">⚔️ Skyrim Optimizer</h5>
                <p class="small mb-0 text-m">
                    Combat Optimization System for analyzing builds, gear, and efficiency.
                </p>
            </div>

            <!-- Middle -->
            <div class="col-md-4 mb-3">
                <h6 class="fw-bold text-lg">Navigation</h6>
                <ul class="list-unstyled text-m">
                    <li><a href="<?= BASE_URL ?>/main/home.php">Home</a></li>
                    <li><a href="<?= BASE_URL ?>/main/references.php">References</a></li>
                </ul>
            </div>

            <!-- Right -->
            <div class="col-md-4 mb-3">
                <h6 class="fw-bold text-lg">About</h6>
                <p class="small mb-0 text-m">
                    Cygnus J. Wiebe<br>
                    McGill University<br>
                    INFS 657 · April 2026
                </p>
            </div>

        </div>

        <hr class="border-light">

        <div class="text-center text-lg">
            <?= date('Y') ?> - Skyrim Combat Optimization System
            <p class="small">Version 1.0 · Build <?= date('Y-m-d') ?></p>
        </div>

    </div>
</footer>