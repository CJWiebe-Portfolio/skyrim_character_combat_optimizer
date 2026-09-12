<?php

/**
 * File: create_character.php
 * Author: Cygnus J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 * Course: INFS 657: Data Design and Development - McGill University
 *
 * Description:
 * Allows a User/Admin to create new characters.
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
$pageTitle = "Create Character";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php include '../page_formatting/header.php'; ?>
<?php include '../page_formatting/navbar.php'; ?>

<?php
$races = [
    1  => 'Altmer',
    2  => 'Argonian',
    3  => 'Bosmer',
    4  => 'Breton',
    5  => 'Dunmer',
    6  => 'Imperial',
    7  => 'Khajiit',
    8  => 'Nord',
    9  => 'Orsimer',
    10 => 'Redguard',
];


/* =========================
   AUTH CHECK
   ========================= */

if (!isset($_SESSION['email'], $_SESSION['account_id'])) {
    header("Location: /infs_657/skyrim_inventory_optimization/website/login/login.php");
    exit();
}

/* =========================
   HANDLE FORM SUBMISSION
   ========================= */

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $name    = $_POST['name'] ?? '';
    $race_id = $_POST['race_id'] ?? '';

    if (empty($name) || empty($race_id)) {
        $error = "All fields are required.";
    } else {

        try {

            /* =========================
               GET NEXT CHARACTER NUMBER
               (per account scope)
               ========================= */

            $stmt = $conn->prepare("
                SELECT COALESCE(MAX(character_number), 0) + 1 AS next_number
                FROM `character`
                WHERE account_id = :account_id
            ");

            $stmt->execute([
                ':account_id' => $_SESSION['account_id']
            ]);

            $next_number = $stmt->fetch(PDO::FETCH_ASSOC)['next_number'];

            /* =========================
               INSERT CHARACTER
               ========================= */

            $stmt = $conn->prepare("
                INSERT INTO `character`
                (name, race_id, account_id, character_number)
                VALUES
                (:name, :race_id, :account_id, :character_number)
            ");

            $stmt->execute([
                ':name' => $name,
                ':race_id' => $race_id,
                ':account_id' => $_SESSION['account_id'],
                ':character_number' => $next_number
            ]);

            header("Location: characters.php?created=1");
            exit();
        } catch (PDOException $e) {
            $error = "Creation failed: " . $e->getMessage();
        }
    }
}
?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!DOCTYPE html>
<html lang="en">

<body>
    <!-- This section provides a form for creating a new character, allowing the user to input the character's name and select a race from a dropdown menu. 
     It also includes error handling to display any issues that arise during the character creation process. -->
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <div class="section-title mb-4">
                        <h1 class="section-title title-main text-center">➕ Create New Character and Inventory</h1>
                        <h5 class="text-muted-custom text-center"> This will create a new character and their initial inventory.</h5>
                    </div>
                    <?php if (isset($error)): ?>
                        <p class="text-danger"><?= htmlspecialchars($error) ?></p>
                    <?php endif; ?>
                    <!-- ========================= CREATE FORM ========================= -->

                    <form method="POST">

                        <div class="mb-3">
                            <label class="form-label text-lg">Character Name</label>
                            <input type="text" name="name" class="form-control text-lg" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-lg" for="race_id">Race</label>
                            <select name="race_id" id="race_id" class="form-select text-lg" required>
                                <option value="">Select a race</option>
                                <?php foreach ($races as $id => $race_name): ?>
                                    <option
                                        value="<?= $id ?>"
                                        <?= ((int) ($race_id ?? 0) === $id) ? 'selected' : '' ?>>
                                        <?= htmlspecialchars($race_name) ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>

                        <div class="d-flex gap-2 mt-4">
                            <button type="submit" class="btn skyrim-btn-create text-lg">
                                💾 Create Character
                            </button>

                            <a href="<?= BASE_URL ?>/my_character/characters.php" class="btn btn-primary text-lg">
                                Back to My Characters
                            </a>

                        </div>

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