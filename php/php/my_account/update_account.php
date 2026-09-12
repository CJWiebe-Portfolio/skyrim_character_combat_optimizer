<?php

/**
 * File: update_account.php
 * Author: Cygnus J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 * Course: INFS 657: Data Design and Development - McGill University
 * 
 * Description:
 * Allows a User/Admin to update the information of their account.
 */
?>

<!-- ============================================================================================ -->
<!-- ====================================== PHP STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- ===================== ACTIVE SESSION & PAGE TITLE ===================== -->
<?php
session_start();
require '../main/database.php';
$pageTitle = "Update Account";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php include '../page_formatting/header.php'; ?>
<?php include '../page_formatting/navbar.php'; ?>

<?php
// Redirect if not logged in
if (!isset($_SESSION['email'])) {
    header("Location: ../login/login.php");
    exit();
}

// Fetch user details for pre-filling the form.
$stmt = $conn->prepare("SELECT * FROM accounts WHERE email = ?");
$stmt->execute([$_SESSION['email']]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

//Handles form submission for updating account information.
$success = "";
$fail = "";

// This block checks if the form has been submitted by looking for the "submit" key in the $_POST array.
// If the form has been submitted, it retrieves the updated account information from the form input, including first name, last name, email, date of birth, and password fields.
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $email = $_POST['email'];
    $date   = $_POST['date'];

    $currentPassword = $_POST['current_password'];
    $newPassword     = $_POST['new_password'];
    $confirmPassword = $_POST['confirm_password'];

    // Basic validation to ensure required fields are not empty. 
    // If any of the required fields (first name, last name, email) are empty, an error message is stored in the $error variable.
    if (empty($first_name) || empty($last_name) || empty($email)) {
        $error = "Please fill in all required fields.";
    } else {

        try {
            // This block checks if the user is attempting to change their password by checking if any of the password fields are filled.
            if (!empty($currentPassword) || !empty($newPassword) || !empty($confirmPassword)) {
                // If the user is attempting to change their password, it performs additional validation to ensure that the current password is correct, the new passwords match, and that the new password meets certain criteria (e.g., minimum length).
                if (empty($currentPassword) || empty($newPassword) || empty($confirmPassword)) {
                    $error = "Please fill in all password fields.";
                } elseif (!password_verify($currentPassword, $user['password'])) {
                    $error = "Current password is incorrect.";
                } elseif ($newPassword !== $confirmPassword) {
                    $error = "New passwords do not match.";
                } elseif (strlen($newPassword) < 8) {
                    $error = "Password must be at least 8 characters.";
                } else {
                    // If all validations pass, the new password is hashed using the password_hash() function with the default algorithm (currently bcrypt) before being stored in the database.
                    $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);

                    // This SQL statement is prepared to update the user's account information in the `accounts` table, including the new password if it was changed.
                    $sql = "UPDATE accounts 
                            SET first_name = ?, last_name = ?, email = ?, date = ?, password = ?
                            WHERE email = ?";
                    $stmt = $conn->prepare($sql);
                    $stmt->execute([$first_name, $last_name, $email, $date, $hashedPassword, $_SESSION['email']]);

                    $_SESSION['email'] = $email;

                    // Refresh user data
                    $stmt = $conn->prepare("SELECT * FROM accounts WHERE email = ?");
                    $stmt->execute([$email]);
                    $user = $stmt->fetch(PDO::FETCH_ASSOC);

                    $success = "Account and password updated successfully!";
                }
            } else {
                // If the user is not changing their password, it simply updates the other account information without modifying the password field in the database.
                $sql = "UPDATE accounts 
                        SET first_name = ?, last_name = ?, email = ?, date = ?
                        WHERE email = ?";
                $stmt = $conn->prepare($sql);
                $stmt->execute([$first_name, $last_name, $email, $date, $_SESSION['email']]);

                $_SESSION['email'] = $email;

                // Refresh user data
                $stmt = $conn->prepare("SELECT * FROM accounts WHERE email = ?");
                $stmt->execute([$email]);
                $user = $stmt->fetch(PDO::FETCH_ASSOC);

                $success = "Account updated successfully!";
            }

        // If any exceptions occur during the database operations, such as connection issues or SQL errors, they are caught and an error message is stored in the $error variable.
        } catch (PDOException $e) {
            $error = "Error: " . $e->getMessage();
        }
    }
}
?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- Format of page for creating a new user account -->
<!DOCTYPE HTML>
<html lang="en">

<body>
    <!-- The page displays a form for updating the user's account information, including fields for first name, last name, email, date of birth, and password. 
         It also shows success or error messages based on the outcome of the update operation. -->
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <h1 class="section-title title-main text-center">✏️ Update <?= htmlspecialchars($user['first_name']) ?> Account ✏️</h1>
                    <h5 class="text-muted-custom text-center">This is all the information you can update for your account</h5>

                    <br>

                    <!-- Success / Error Messages -->
                    <?php if ($success): ?>
                        <div class="alert alert-success text-lg"><?= $success ?></div>
                    <?php endif; ?>

                    <?php if ($error): ?>
                        <div class="alert alert-danger text-lg"><?= $error ?></div>
                    <?php endif; ?>

                    <!-- Update Form -->
                    <form method="POST">

                        <div class="mb-3">
                            <label class="form-label text-lg">First Name</label>
                            <input value="<?= htmlspecialchars($user['first_name']) ?>"
                                name="first_name" type="text" class="form-control text-lg" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-lg">Last Name</label>
                            <input value="<?= htmlspecialchars($user['last_name']) ?>"
                                name="last_name" type="text" class="form-control text-lg" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-lg">Email [e.g. email@email.email]</label>
                            <input value="<?= htmlspecialchars($user['email']) ?>"
                                name="email" type="email" class="form-control text-lg" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-lg">Date of Birth</label>
                            <input value="<?= htmlspecialchars($user['date']) ?>"
                                name="date" type="date" class="form-control text-lg">
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-lg">Current Password</label>
                            <input name="current_password" type="password" class="form-control text-lg">
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-lg">New Password</label>
                            <input name="new_password" type="password" class="form-control text-lg">
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-lg">Confirm New Password</label>
                            <input name="confirm_password" type="password" class="form-control text-lg">
                        </div>
                        <br>
                        <div>
                            <button type="submit" class="skyrim-btn skyrim-btn-update text-center text-lg">
                                ✏️ Update Account Information
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    <!-- ===================== SCRIPTS ===================== -->
    <?php require_once '../page_formatting/scripts.php'; ?>
</body>
<!-- ===================== FOOTER ===================== -->
<?php require_once '../page_formatting/footer.php'; ?>


</html>