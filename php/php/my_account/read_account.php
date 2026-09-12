<?php

/**
 * File: read_account.php
 * Author: Cygnus J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 * Course: INFS 657: Data Design and Development - McGill University
 *
 * Description:
 * Allows a User/Admin to read the information of their account.
 *
 */
?>

<!-- ============================================================================================ -->
<!-- ====================================== PHP STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- ===================== ACTIVE SESSION & PAGE TITLE ===================== -->
<?php
session_start();
require '../main/database.php';
$pageTitle = "My Account";
$q1 = "SELECT * FROM `accounts` WHERE email = ?";
$stmt = $conn->prepare($q1);
$stmt->execute([$_SESSION['email']]);
?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php include '../page_formatting/header.php'; ?>
<?php include '../page_formatting/navbar.php'; ?>

<!DOCTYPE HTML>
<html lang="en">
<body>
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <!-- The page displays the account information of the logged-in user, including their first name, last name, email, and date of birth. 
                     It also provides buttons for updating account information and deleting the account. -->
                    <div class="section-title">
                        <h1 class="section-title title-main text-center">🧾 Account Information 🧾</h1>
                        <h5 class="text-muted-custom text-center">
                            This is the account information of <?= $_SESSION['email'] ?>
                        </h5>
                    </div>
                    <div class="row g-3 mb-4">

                        <div class="col-md-6">
                            <div class="p-3 text-center">
                                <a href="<?= BASE_URL ?>/my_account/update_account.php"
                                    class="skyrim-btn skyrim-btn-update text-lg">
                                    ✏️ Update Account Information
                                </a>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="p-3 text-center">
                                <a href="<?= BASE_URL ?>/my_account/delete_account.php"
                                    class="skyrim-btn skyrim-btn-delete text-lg">
                                    🗑️ Delete Account
                                </a>
                            </div>
                        </div>

                    </div>
                    <table class="table-skyrim text-lg">
                        <thead>
                            <tr>
                                <th>First Name</th>
                                <th>Last Name</th>
                                <th>Email</th>
                                <th>Date of Birth</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php

                            while ($accounts = $stmt->fetch(PDO::FETCH_ASSOC)) {
                            ?>
                                <!-- ROW 1 - START -->
                                <tr>
                                    <td><?php echo $accounts["first_name"] ?></td>
                                    <td><?php echo $accounts["last_name"] ?></td>
                                    <td><?php echo $accounts["email"] ?></td>
                                    <td><?php echo $accounts["date"] ?></td>
                                </tr>
                            <?php

                            } ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    <!-- ===================== SCRIPTS ===================== -->
    <?php require_once '../page_formatting/scripts.php'; ?>
</body>
<!-- ===================== FOOTER ===================== -->
<?php require_once '../page_formatting/footer.php'; ?>

</html>