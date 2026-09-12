<?php

/**
 * File: update_character.php
 * Author: C.J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 *
 * Description:
 * Allows a User/Admin to update the information for each of their selected characters.
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
$pageTitle = "Edit Character";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php require_once '../page_formatting/header.php'; ?>
<?php require_once '../page_formatting/navbar.php'; ?>

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
    header('Location: /skyrim_inventory_optimization/website/login/login.php');
    exit();
}

/* =========================
   VALIDATE ID
   ========================= */

if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
    die('Invalid character ID.');
}

$character_id = (int) $_GET['id'];

/* =========================
   FETCH EXISTING DATA
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
        ':account_id' => $_SESSION['account_id'],
    ]);

    $character = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$character) {
        die('Character not found or access denied.');
    }
} catch (PDOException $e) {
    die('Database error: ' . $e->getMessage());
}

/* =========================
   HANDLE FORM SUBMISSION
   ========================= */

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');
    $race_id = isset($_POST['race_id']) ? (int) $_POST['race_id'] : 0;

    if ($name === '' || !array_key_exists($race_id, $races)) {
        $error = 'Please enter a character name and choose a valid race.';
        $character['name'] = $name;
        $character['race_id'] = $race_id;
    } else {
        try {
            $stmt = $conn->prepare("
                UPDATE `character`
                SET name = :name,
                    race_id = :race_id
                WHERE character_id = :id
                AND account_id = :account_id
            ");

            $stmt->execute([
                ':name' => $name,
                ':race_id' => $race_id,
                ':id' => $character_id,
                ':account_id' => $_SESSION['account_id'],
            ]);

            header('Location: read_character.php?id=' . $character_id);
            exit();
        } catch (PDOException $e) {
            $error = 'Update failed: ' . $e->getMessage();
            $character['name'] = $name;
            $character['race_id'] = $race_id;
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
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <div class="section-title mb-4">
                        <h1 class="title-main">✏️ Editing Character <?= htmlspecialchars($character['name']) ?></h1>
                    </div>
                    <?php if (isset($error)): ?>
                        <p class="text-danger"><?= htmlspecialchars($error) ?></p>
                    <?php endif; ?>

                    <form method="POST">
                        <div class="mb-3">
                            <label class="form-label">Character Name</label>
                            <input
                                type="text"
                                name="name"
                                class="form-control"
                                value="<?= htmlspecialchars($character['name']) ?>"
                                required
                            >
                        </div>

                        <div class="mb-3">
                            <label class="form-label" for="race_id">Race</label>
                            <select name="race_id" id="race_id" class="form-select" required>
                                <option value="">Select a race</option>
                                <?php foreach ($races as $id => $race_name): ?>
                                    <option
                                        value="<?= $id ?>"
                                        <?= (isset($character['race_id']) && (int) $character['race_id'] === $id) ? 'selected' : '' ?>
                                    >
                                        <?= htmlspecialchars($race_name) ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>

                        <div class="d-flex gap-2 mt-4">
                            <button type="submit" class="btn skyrim-btn-update">
                                💾 Update Character
                            </button>
                            <a href="<?= BASE_URL ?>/my_character/characters.php" class="btn btn-primary">
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