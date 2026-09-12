<?php
/**
 * =========================================================
 * FILE: create_user.php
 * PROJECT: Skyrim Character Combat Optimization System
 * AUTHOR: C.J. Wiebe
 * DATE: April 2026
 * =========================================================
 * DESCRIPTION:
 * Creates user accounts and stores them in the table `accounts` of the database. 
 * Validates password strength and confirmation.
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
$pageTitle = "Create User";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php require_once '../page_formatting/header.php'; ?>
<?php require_once '../page_formatting/navbar.php'; ?>

<?php
// This initializes the $success and $error variables to store messages that will be displayed to the user after form submission.
$success = "";
$error = "";

//Handles the form submission when the "Submit" button is clicked. It checks if the form has been submitted by looking for the "submit" key in the $_POST array.
if (isset($_POST["submit"])) {

    // Retrieves the password and confirmation password from the form input. 
    // The password is expected to be in the 'password_hash' field, and the confirmation in 'password_confirm'.
    $password = $_POST['password_hash'];
    $confirm_password = $_POST['password_confirm'];

    // This block performs server-side validation of the password. It checks if the password and confirmation match, 
    // if the password is at least 8 characters long, and if it contains at least one letter, one number, and one special character. 
    //If any of these conditions fail, an appropriate error message is stored in the $error variable. 
    //Only if all validations pass does it proceed to hash the password using password_hash() before storing it in the database.
    if ($password !== $confirm_password) {
        $error = "Passwords do not match.";
    } elseif (strlen($password) < 8) {
        $error = "Password must be at least 8 characters.";
    } elseif (!preg_match('/[A-Za-z]/', $password)) {
        $error = "Password must contain at least one letter.";
    } elseif (!preg_match('/[0-9]/', $password)) {
        $error = "Password must contain at least one number.";
    } elseif (!preg_match('/[\W_]/', $password)) {
        $error = "Password must contain at least one special character.";
    } else {
        // If all validations pass, the password is hashed using the password_hash() function with the default algorithm (currently bcrypt).
        $hash = password_hash($password, PASSWORD_DEFAULT);
    }
    // If there are no errors after validation, this block prepares the user data for insertion into the database.
    if (empty($error)) {

        $user_data = [
            $_POST['first_name'],
            $_POST['last_name'],
            $_POST['email'],
            $_POST['date'],
            $hash
        ];
        // This SQL statement is prepared to insert the new user's data into the `accounts` table.
        $sql = "INSERT INTO accounts (first_name, last_name, email, date, password) VALUES (?,?,?,?,?)";
        // The code then attempts to execute the prepared statement with the user data. 
        // If the execution is successful, it redirects the user to a success.php page.
        try {
            $stmt = $conn->prepare($sql);

            if ($stmt->execute($user_data)) {
                header("Location: ../account/success.php");
                exit;
            } else {
                $error = "Something went wrong while saving the user.";
            }
        } catch (PDOException $e) {
            $error = "Database error: " . $e->getMessage();
        }
    }
}
?>
<!-- Displays success or error messages to the user when they submit the form. -->
<?php if (!empty($success)): ?>
    <div class="alert alert-success text-center rounded-0 mb-0" id="topAlert">
        <?= htmlspecialchars($success) ?>
    </div>
<?php endif; ?>

<?php if (!empty($error)): ?>
    <div class="alert alert-danger text-center rounded-0 mb-0" id="topAlert">
        <?= htmlspecialchars($error) ?>
    </div>
<?php endif; ?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!-- Format of page for creating a new user account -->
<html>

<body>
    <!-- This section contains a form for creating a new user account. 
     It includes fields for first name, last name, email, date of birth, password, and password confirmation. -->
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <!-- ===================== HEADER ===================== -->
                    <h1 class="section-title title-main text-center"> Create an Account </h1>
                    <h5 class="text-muted-custom text-center"> With an account you will be able to create characters and build their inventories </h5>
                    <!-- ===================== FORM ===================== -->
                    <br>
                    <form method="POST" action="#">
                        <div class="mb-3">
                            <label class="form-label text-lg">* First Name</label>
                            <input name="first_name" type="text" class="form-control text-lg">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-lg">* Last Name</label>
                            <input name="last_name" type="text" class="form-control text-lg">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-lg">* Email [e.g. email@email.email]</label>
                            <input name="email" type="email" class="form-control text-lg">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-lg">* Date of Birth</label>
                            <input name="date" type="date" class="form-control text-lg">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-lg">* Choose Password</label>
                            <input name="password_hash" type="password" class="form-control text-lg"
                                pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[\W_]).{8,}$"
                                title="At least 8 characters, including a letter, number, and special character">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-lg">* Confirm Password</label>
                            <input name="password_confirm" type="password" class="form-control text-lg"
                                pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[\W_]).{8,}$"
                                title="At least 8 characters, including a letter, number, and special character">
                        </div>
                        <br>
                        <!-- ===================== SUBMIT BUTTON ===================== -->
                        <button name="submit" type="submit" class="btn skyrim-btn-create text-lg">Submit</button>
                    </form>
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