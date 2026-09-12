<?php

/**
 * File: login.php
 * Author: Cygnus J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 * Course: INFS 657: Data Design and Development - McGill University
 *
 * Description:
 * This is the login page for Admin and Users in order to gain exclusive access to specific web pages.
 * It validates the email and password against the database and starts a session for the logged-in user.
 * It also handles error messages for incorrect email or password and displays them to the user.
 * 
 */
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php include '../page_formatting/header.php'; ?>
<?php include '../page_formatting/navbar.php'; ?>

<!-- ============================================================================================ -->
<!-- ====================================== PHP STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- ===================== ACTIVE SESSION & PAGE TITLE ===================== -->
<?php
session_start();
include '../main/database.php';
$pageTitle = "Login";
ini_set('display_errors', 1);
error_reporting(E_ALL);

// This initializes the $error variable to store any error messages that may occur during the login process.
$error = '';

//Only runs the code if the form is submitted using POST method.
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Gets and sanitizes the email and password from the form submission.
    $email = $_POST['email'];
    $password = $_POST['password'];

    try {
        //Prepares and executes a SQL statement to fetch the account record based on the provided email.
        $stmt = $conn->prepare("SELECT account_id, first_name, email, password, role FROM accounts WHERE email = :email");
        $stmt->execute(['email' => $email]);

        //fetches the account record as an associative array. If an account is found, it verifies the password using password_verify() function.
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        // If the password is correct, it sets session variables for the user's account ID, email, first name, and role.
        if ($user) {
            if (password_verify($password, $user['password'])) {
                $_SESSION['account_id'] = $user['account_id'];
                $_SESSION['email'] = $user['email'];
                $_SESSION['first_name'] = $user['first_name'];
                $_SESSION['role'] = $user['role'];


                // Redirects the user to the home page after successful login.
                header("Location: ../main/home.php");
                exit();

                //Error messages are set if the email is found but the password is incorrect.
            } else {
                $error = "Incorrect password!";
            }

            //displays an error message if no user is found with the provided email.
        } else {
            $error = "Email not found!";
        }
        // Catches any database-related exceptions and sets an error message with the exception details.
    } catch (PDOException $e) {
        $error = "Database error: " . $e->getMessage();
    }
}
?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- Format of page for logging in -->
<html>

<body>
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <!-- ===================== HEADER ===================== -->
                    <div class="section-title text-left">
                        <h2 class="section-title title-main text-center">Login</h2>
                        <?php if (isset($error)) echo "<p style='color:red;'>$error</p>"; ?>
                        <!-- ===================== LOGIN FORM ======== class="rt"============= -->
                        <form method="POST" action="#" class="text-muted-custom">
                            <label class="form-label text-lg">Email:</label>
                            <input type="email" name="email" required class="form-control text-lg"><br>
                            <label class="form-label text-lg">Password:</label>
                            <input type="password" name="password" required class="form-control text-lg"><br>
                            <button name="Login" type="submit" class="btn btn-primary text-lg">Sign In</button>
                        </form>
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