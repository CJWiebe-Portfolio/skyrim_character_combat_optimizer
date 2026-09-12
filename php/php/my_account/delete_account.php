<?php
/**
 * File: delete_account.php
 * Author: Cygnus J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 * Course: INFS 657: Data Design and Development - McGill University
 *
 * Description:
 * Allows a user or a admin to delete their account.
 *
 */
?>

<!-- ============================================================================================ -->
<!-- ====================================== PHP STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- ===================== ACTIVE SESSION & PAGE TITLE ===================== -->
<?php
//Continues the previous session.
session_start();
require '../main/database.php';
$pageTitle = "Delete Account";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<!DOCTYPE HTML>
<html lang="en">
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
$error = "";

// This block checks if the form has been submitted by looking for the "delete_account" key in the $_POST array.
// If the form has been submitted, it prepares a SQL statement to delete the user's account from the "accounts" table based on their email address.
if (isset($_POST['delete_account'])) {
    $sql = "DELETE FROM accounts WHERE email = ?";
    $stmt = $conn->prepare($sql);
    if ($stmt->execute([$_SESSION['email']])) {
        session_destroy();
        header("Location: ../main/home.php");
        exit();
    } else {
        $error = "An error occurred while trying to delete your account.";
        exit();
    }
}
?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- Format of page for deleting an account -->
<body>
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <h1 class="section-title text-center">You are about to delete your account?</h1>
                    <h5 class="text-muted-custom text-center">There is no return from this action! 😭</h5>
                    <br>
                    <form method="POST">
                        <button name="delete_account" type="submit" class="skyrim-btn skyrim-btn-delete text-xl">
                            🗑️ I accept my fate and wish to delete the account. 🗑️
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <?php require_once '../page_formatting/scripts.php'; ?>
</body>


<?php require_once '../page_formatting/footer.php'; ?>


</html>