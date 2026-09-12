<?php
/**
 * File: characters.php
 * Author: Cygnus J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 * Course: INFS 657: Data Design and Development - McGill University
 *
 * Description:
 * Allows a User/Admin to see all the characters associated with their accounts.
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
$pageTitle = "My Characters";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php include '../page_formatting/header.php'; ?>
<?php include '../page_formatting/navbar.php'; ?>

<?php
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

/* =========================
   FILTER + SORT PARAMETERS
   ========================= */

$category = $_GET["category"] ?? "";
$sort     = $_GET["sort"] ?? "";
$order    = ($_GET["order"] ?? "ASC") === "DESC" ? "DESC" : "ASC";

/* =========================
   BASE QUERY
   ========================= */

$sql = "SELECT * FROM `character` WHERE account_id = :account_id";
$params = [
    ':account_id' => $_SESSION['account_id']
];

if (!isset($_SESSION['email'], $_SESSION['account_id'])) {
    header("Location: /infs_657/skyrim_inventory_optimization/website/login/login.php");
    exit();
}

/* SORT (WHITELISTED) */
$allowedSort = ["name"];
if (in_array($sort, $allowedSort)) {
    $sql .= " ORDER BY $sort $order";
}

$stmt = $conn->prepare($sql);
$stmt->execute($params);
?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!DOCTYPE html>
<html lang="en">

<body>
    <!-- This section displays the user's characters in a table format, allowing them to view details, access their inventory, and perform actions such as viewing characters details, editing or deleting characters. 
         It also includes a form for filtering and sorting the characters based on different criteria. -->
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <div class="section-title">
                        <h1 class="section-title title-main text-center">👥 Viewing Characters of <?= htmlspecialchars($_SESSION['first_name']) ?> 👥</h1>
                        <h5 class="text-muted-custom text-center"> This is all the characters you have created </h5>
                    </div>
                    <br>
                    <!-- ========================= CREATE CHARACTER BUTTON ========================= -->  
                    <div class="col-md-5">
                        <div class="p-3 text-center">
                            <a href="<?= BASE_URL ?>/my_character/create_character.php"
                                class="skyrim-btn skyrim-btn-create text-lg">
                                ➕ Create New Character with a Inventory
                            </a>
                        </div>
                    </div>
                    <br>
                    <!-- ========================= FILTER + SORT FORM ========================= -->
                    <form method="GET" class="row mb-4 align-items-end skyrim-filter col-md-8">

                        <!-- Sort -->
                        <div class="col-md-5 ">
                            <label class="form-label">Sort By</label>
                            <select name="sort" class="form-select">
                                <option value="">None</option>
                                <option value="character_number" <?= ($sort == "character_number") ? "selected" : "" ?>>Character Number</option>
                                <option value="race_id" <?= ($sort == "race_id") ? "selected" : "" ?>>Race</option>
                                <option value="name" <?= ($sort == "name") ? "selected" : "" ?>>Name</option>
                            </select>
                        </div>

                        <!-- order -->
                        <div class="col-md-5">
                            <label class="form-label">Order</label>
                            <select name="order" class="form-select">
                                <option value="ASC" <?= ($order == "ASC") ? "selected" : "" ?>>Ascending</option>
                                <option value="DESC" <?= ($order == "DESC") ? "selected" : "" ?>>Descending</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-warning w-100">Apply</button>
                        </div>
                    </form>
                    <!-- ========================= DATA TABLE ========================= -->
                    <table class="table-skyrim text-lg">
                        <thead>
                            <tr>
                                <th>Character Number</th>
                                <th>Race</th>
                                <th>Name</th>
                                <th>Inventory</th>
                                <th>Modify</th>
                            </tr>
                        </thead>
                        <!-- The table body is populated with character data fetched from the database. Each row represents a character, displaying their character information. -->
                        <tbody class="text-center">
                            <?php while ($character = $stmt->fetch(PDO::FETCH_ASSOC)): ?>
                                <tr>
                                    <td><?= $character["character_number"] ?></td>
                                    <td><?= $race[$character['race_id']] ?? "Unknown" ?></td>
                                    <td><?= $character["name"] ?></td>
                                    <!-- Each character row includes buttons for viewing the character's inventory, viewing character details, editing the character, and deleting the character. -->
                                    <td>
                                        
                                        <a href="inventory.php?character_id=<?= $character['character_id'] ?>"
                                            class="btn btn-primary text-lg">
                                            🎒 <?= htmlspecialchars($character['name']) ?>'s Inventory 🎒</a>
                                    </td>
                                    <td>
                                        <a href="read_character.php?id=<?= $character['character_id'] ?>"
                                            class="btn btn-info btn-sm text-lg">👁️
                                        </a>
                                        <a href="update_character.php?id=<?= $character['character_id'] ?>"
                                            class="btn btn-warning btn-sm text-lg">✏️</a>
                                        <form method="POST" action="delete_character.php" style="display:inline;">
                                            <input type="hidden" name="character_id" value="<?= $character['character_id'] ?>">
                                            <button type="submit" class="btn btn-danger btn-sm text-lg"
                                                onclick="return confirm('Are you sure you want to delete this character?');">
                                                ✖️
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <?php endwhile; ?>
                        </tbody>
                    </table>
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