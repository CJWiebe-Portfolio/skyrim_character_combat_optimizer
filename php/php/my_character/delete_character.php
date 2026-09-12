<?php
/**
 * File: delete_character.php
 * Author: Cygnus J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 * Course: INFS 657: Data Design and Development - McGill University
 *
 * Description:
 * Allows a User/Admin to delete their selected characters.
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
$pageTitle = "Delete Character";
?>

<?php
/* =========================
   AUTH CHECK
   ========================= */


if (!isset($_SESSION['email'], $_SESSION['account_id'])) {
    header("Location: /infs_657/skyrim_inventory_optimization/website/login/login.php");
    exit();
}


/* =========================
   HANDLE DELETE REQUEST
   ========================= */


if ($_SERVER['REQUEST_METHOD'] === 'POST') {


    if (!isset($_POST['character_id']) || !is_numeric($_POST['character_id'])) {
        die("Invalid character ID.");
    }


    $character_id = (int) $_POST['character_id'];


    try {
        $stmt = $conn->prepare("
            DELETE FROM `character`
            WHERE character_id = :id
            AND account_id = :account_id
        ");


        $stmt->execute([
            ':id' => $character_id,
            ':account_id' => $_SESSION['account_id']
        ]);


        // Optional: check if anything was actually deleted
        if ($stmt->rowCount() === 0) {
            die("Character not found or access denied.");
        }


        // Redirect back to character list
        header("Location: characters.php");
        exit();


    } catch (PDOException $e) {
        die("Delete failed: " . $e->getMessage());
    }


} else {
    // Prevent direct access via GET
    header("Location: characters.php");
    exit();
}
?>