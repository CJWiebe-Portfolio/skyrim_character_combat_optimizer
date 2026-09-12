<?php

/**
 * File: references.php
 * Author: C.J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 *
 * Description:
 * Provides assignment specific information.
 * This page lists the references used in the project, including the game itself, wikis for game mechanics, and resources for web development.
 * 
 */
?>

<!-- ============================================================================================ -->
<!-- ====================================== PHP STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- ===================== ACTIVE SESSION & PAGE TITLE ===================== -->
<?php
session_start();
include '../main/database.php';
$pageTitle = "References";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<!DOCTYPE HTML>
<html lang="en">
<?php include '../page_formatting/header.php'; ?>
<?php include '../page_formatting/navbar.php'; ?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->

<body>
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <!-- The page displays a section title "References" and a list of references used in the project, including the game itself, wikis for game mechanics, and resources for web development. Each reference includes a brief description and a link to the source. -->
                    <h1 class="section-title title-main text-center">📚 References 📚</h1>
                    <h5 class="text-muted-custom text-center"> This project would not be possible without the contributions of the Skyrim community.</h5>
                    <br>
                    <p / class="text-muted-custom text-lg">
                        Howard, Todd. The Elder Scrolls V: Skyrim. 2011; Bethesda Softworks.
                        <a href="https://elderscrolls.bethesda.net/en/skyrim10" target="_blank">
                            https://elderscrolls.bethesda.net/en/skyrim10
                        </a>

                    </p>
                    <p class="text-muted-custom text-lg">
                        Elmartian. “Skyrim Weapons Dataset.” Kaggle. Accessed March 1, 2026.
                        <a href="https://www.kaggle.com/datasets/elmartini/skyrim-weapons-dataset" target="_blank">
                            https://www.kaggle.com/datasets/elmartini/skyrim-weapons-dataset
                        </a>
                    </p>
                    <p class="text-muted-custom text-lg">
                        Edmilson Silva. “The Elder Scrolls Skyrim - Armor.” Accessed March 1, 2026.
                        <a href="https://www.kaggle.com/datasets/sc0v1n0/the-elder-scroll-skyrim-armor" target="_blank">
                            https://www.kaggle.com/datasets/sc0v1n0/the-elder-scroll-skyrim-armor
                        </a>
                    </p>
                    <p class="text-muted-custom text-lg">
                        Skyrim Races + Base Stats.” Accessed March 1, 2026.
                        <a href="https://www.kaggle.com/datasets/stephenofarrell/skyrim-races-base-stats" target="_blank">
                            https://www.kaggle.com/datasets/stephenofarrell/skyrim-races-base-stats
                        </a>
                    </p>
                    <p class="text-muted-custom text-lg">
                        “The Elder Scrolls V: Skyrim - UESP Wiki - The Unofficial Elder Scrolls Pages.” Accessed March 1, 2026.
                        <a href="https://en.uesp.net/wiki/Skyrim:Skyrim" target="_blank">
                            https://en.uesp.net/wiki/Skyrim:Skyrim
                        </a>
                    </p>
                    <p class="text-muted-custom text-lg">
                        “Skyrim Desktop Backgrounds - Wallpaper Cave.” Accessed March 1, 2026.
                        <a href="https://wallpapercave.com/skyrim-desktop-backgrounds" target="_blank">
                            https://wallpapercave.com/skyrim-desktop-backgrounds
                        </a>
                    </p>
                    <p class="text-muted-custom text-lg">
                        contributors, Mark Otto, Jacob Thornton, and Bootstrap. “Bootstrap.” Accessed March 1, 2026. https://getbootstrap.com/.
                        <a href="https://getbootstrap.com/" target="_blank">
                            https://getbootstrap.com/
                        </a>
                    </p>
                    <p class="text-muted-custom text-lg">
                        “W3Schools Online Web Tutorials.” Accessed March 1, 2026. https://www.w3schools.com/.
                        <a href="https://www.w3schools.com/" target="_blank">
                            https://www.w3schools.com/
                        </a>
                    </p>
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