<?php

/**
 * File: read_character.php
 * Author: Cygnus J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 * Course: INFS 657: Data Design and Development - McGill University
 *
 * Description:
 * Allows a User/Admin to read the information for each of their selected characters.
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
$pageTitle = "Character Details";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php require_once '../page_formatting/header.php'; ?>
<?php require_once '../page_formatting/navbar.php'; ?>

<?php
/* =========================
   AUTH CHECK
   ========================= */

if (!isset($_SESSION['email'], $_SESSION['account_id'])) {
    header("Location: /infs_657/skyrim_inventory_optimization/website/login/login.php");
    exit();
}

/* =========================
   VALIDATE INPUT
   ========================= */

if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
    die("Invalid character ID.");
}

$character_id = (int) $_GET['id'];

/* =========================
   FETCH CHARACTER
   ========================= */

try {
    $stmt = $conn->prepare("
        SELECT *
        FROM `character`
        WHERE character_id = :id
        AND account_id = :account_id
    ");

    $stmt->execute([
        ':id' => $character_id,
        ':account_id' => $_SESSION['account_id']
    ]);

    $character = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$character) {
        die("Character not found or access denied.");
    }
} catch (PDOException $e) {
    die("Database error: " . $e->getMessage());
}

/* =========================
   Race Lookup Table
   ========================= */

$race = [
    1  => "Altmer",
    2  => "Argonian",
    3  => "Bosmer",
    4  => "Breton",
    5  => "Dunmer",
    6  => "Imperial",
    7  => "Khajiit",
    8  => "Nord",
    9  => "Orsimer",
    10 => "Redguard"
];

?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!DOCTYPE html>
<html lang="en">

<body>
    <!-- This section displays the character's name and a back button to return to the character list. -->
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <div class="section-title mb-4">
                        <h1 class="title-main">
                            🧝 Character Details: <?= htmlspecialchars($character['name']) ?></h1>

                        <!-- CHARACTER DETAILS -->
                        <table class="table-skyrim text-lg">
                            <tr>
                                <th>   Character ID</th>
                                <td> <?= $character['character_id'] ?></td>
                            </tr>
                            <tr>
                                <th>   Name</th>
                                <td> <?= htmlspecialchars($character['name']) ?></td>
                            </tr>
                            <tr>
                                <th>   Race ID</th>

                                <td> <?= $race[$character['race_id']] ?? "Unknown" ?></td>
                            </tr>
                        </table>

                        <!-- ACTION BUTTONS -->
                        <div class="gap-2 mt-4">
                            <a href="<?= BASE_URL ?>/my_character/characters.php" class="btn btn-primary">
                                Back to My Characters
                            </a>
                            <a href="<?= BASE_URL ?>/my_character/update_character.php?id=<?= $character['character_id'] ?>" class="btn skyrim-btn-update">
                                💾 Update Character 💾
                            </a>

                            <form method="POST" action="delete_character.php" style="display:inline;">
                                <input type="hidden" name="character_id" value="<?= $character['character_id'] ?>">
                                <button type="submit" class="btn skyrim-btn-delete" onclick="return confirm('Are you sure you want to delete this character?');">
                                    🗑️ Delete this character 🗑️
                                </button>
                            </form>
                        </div>
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