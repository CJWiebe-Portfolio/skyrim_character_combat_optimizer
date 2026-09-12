<?php
/**
 * =========================================================
 * FILE: all_items.php
 * PROJECT: Skyrim Character Combat Optimization System
 * AUTHOR: C.J. Wiebe
 * DATE: April 2026
 * =========================================================
 * DESCRIPTION:
 * Shows the information for all weapons and armours of skyrim, with the ability to sort the items.
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
$pageTitle = "All Armour and Weapons of Skyrim";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php include '../page_formatting/header.php'; ?>
<?php include '../page_formatting/navbar.php'; ?>

<?php
/* ========================= FILTER + SORT PARAMETERS ========================= */

$category = $_GET["category"] ?? "";
$sort     = $_GET["sort"] ?? "";
$order    = ($_GET["order"] ?? "ASC") === "DESC" ? "DESC" : "ASC";

/* ========================= BASE QUERY ========================= */

// The base SQL query selects all items from the `item` table. 
// The "WHERE 1=1" allows for easy appending of additional conditions without worrying about whether to add "WHERE" or "AND".
$sql = "SELECT * FROM item WHERE 1=1";
$params = [];

/* ========================= CATEGORY FILTER ========================= */
if (!empty($category)) {
    $sql .= " AND category_id = :category";
    $params[":category"] = $category;
}

/* ========================= SORT (WHITELISTED) ========================= */
$allowedSort = ["name", "defence", "damage", "speed", "weight", "gold_value", "category_id", "classification_id", "perk_id", "item_upgrade"];
if (in_array($sort, $allowedSort)) {
    $sql .= " ORDER BY $sort $order";
}

/* ========================= EXECUTE QUERY ========================= */
$stmt = $conn->prepare($sql);
$stmt->execute($params);

/* ================================================ DATA MAPPINGS ====================================================== */

/* ========================= CATEGORY MAPPING ========================= */
$categories = [
    1  => "Helmet",
    2  => "Armour",
    3  => "Gauntlets",
    4  => "Boots",
    17  => "Bolts",
    6  => "Sword",
    7  => "Dagger",
    8  => "War Axe",
    9  => "Mace",
    10 => "Battle Axe",
    11 => "Great Sword",
    12 => "Warhammer",
    13 => "Bow",
    14 => "Crossbow",
    15 => "Utensil",
    16 => "Arrow"
];

/* ========================= CLASSIFICATION (ABILITIES) ========================= */
$classifications = [
    1 => "Light Armour",
    2 => "Heavy Armour",
    3 => "One-Handed",
    4 => "Two-Handed",
    5 => "Archery"
];

/* ========================= PERKS ========================= */
$perks = [
    1  => "Steel",
    2  => "Elven",
    3  => "Dwarven",
    4  => "Orcish",
    5  => "Advanced",
    6  => "Glass",
    7  => "Ebony",
    8  => "Daedric",
    9  => "Dragon",
    10 => "Steel or Advanced",
    11 => "Firewood"
];

/* ========================= UPGRADE MATERIALS ========================= */
$upgrades = [
    1  => "Iron Ingot",
    2  => "Steel Ingot",
    3  => "Corundum Ingot",
    4  => "Orichalcum Ingot",
    5  => "Ebony Ingot",
    6  => "Dwarven Metal Ingot",
    7  => "Quicksilver Ingot",
    8  => "Refined Moonstone",
    9  => "Refined Malachite",
    10 => "Dragon Bone",
    11 => "Dragon Scales",
    12 => "Chitin Plate",
    13 => "Chaurus Chitin",
    14 => "Stalhrim",
    15 => "Leather",
    16 => "Void Salts",
    17 => "Bone Meal",
    18 => "Gold Ingot",
    19 => "Daedra Heart and Ebony Ingot",
    20 => "Leather Strips",
    21 => "Corundum Ingot and Ectoplasm",
    22 => "Silver Ingot"
];
?>

<!-- ============================================================================================ -->
<!-- ===================================== HTML STRUCTURE ======================================= -->
<!-- ============================================================================================ -->
<!DOCTYPE html>
<html lang="en">

<body>
    <!-- This section contains a form for filtering and sorting the items. 
    It includes dropdowns for category, sort by, and order (ascending/descending). 
    It also displays the filtered and sorted items.-->
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <div class="section-title">
                        <h1 class="section-title title-main text-center">🛡️ Viewing All Items ⚔️</h1>
                        <h5 class="text-muted-custom text-center"> This includes all the items in the base game and all of the downloaded content </h5>
                    </div>
                    <br>
                    <!-- ========================= FILTER + SORT FORM ========================= -->
                    <form method="GET" class="row mb-4 align-items-end skyrim-filter col-md-12">
                        <div class="col-md-4">
                            <label class="form-label">Category</label>
                            <select name="category" class="form-select">
                                <option value="">All</option>
                                <?php foreach ($categories as $id => $name): ?>
                                    <option value="<?= $id ?>" <?= ($category == $id) ? "selected" : "" ?>>
                                        <?= $name ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Sort By</label>
                            <select name="sort" class="form-select">
                                <option value="">None</option>
                                <option value="name" <?= ($sort == "name") ? "selected" : "" ?>>Name</option>
                                <option value="defence" <?= ($sort == "defence") ? "selected" : "" ?>>Defence</option>
                                <option value="damage" <?= ($sort == "damage") ? "selected" : "" ?>>Damage</option>
                                <option value="speed" <?= ($sort == "speed") ? "selected" : "" ?>>Speed</option>
                                <option value="weight" <?= ($sort == "weight") ? "selected" : "" ?>>Weight</option>
                                <option value="gold_value" <?= ($sort == "gold_value") ? "selected" : "" ?>>Gold</option>
                                <option value="category_id" <?= ($sort == "category_id") ? "selected" : "" ?>>Category</option>
                                <option value="classification_id" <?= ($sort == "classification_id") ? "selected" : "" ?>>Classification</option>
                                <option value="perk_id" <?= ($sort == "perk_id") ? "selected" : "" ?>>Perk</option>
                                <option value="item_upgrade" <?= ($sort == "item_upgrade") ? "selected" : "" ?>>Upgrade</option>
                            </select>
                        </div>
                        <div class="col-md-3">
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


                    <!-- This is the data table for displaying the filtered and sorted items -->
                    <table class="table-skyrim text-lg">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Damage</th>
                                <th>Speed</th>
                                <th>Defence</th>
                                <th>Weight</th>
                                <th>Gold</th>
                                <th>Category</th>
                                <th>Classification</th>
                                <th>Perk</th>
                                <th>Upgrade</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php while ($item = $stmt->fetch(PDO::FETCH_ASSOC)): ?>

                                <!-- Calculate speed based on category (if it's a weapon) -->  
                                <?php
                                if ($item["category_id"] == 6) {
                                    $item["speed"] = 1.0;
                                }
                                if ($item["category_id"] == 7) {
                                    $item["speed"] = 1.3;
                                }
                                if ($item["category_id"] == 8) {
                                    $item["speed"] = 0.9;
                                }
                                if ($item["category_id"] == 9) {
                                    $item["speed"] = 0.8;
                                }
                                if ($item["category_id"] == 10) {
                                    $item["speed"] = 0.7;
                                }
                                if ($item["category_id"] == 11) {
                                    $item["speed"] = 0.7;
                                }
                                if ($item["category_id"] == 12) {
                                    $item["speed"] = 0.6;
                                }
                                if ($item["category_id"] == 13) {
                                    $item["speed"] = 0.9;
                                }
                                if ($item["category_id"] == 14) {
                                    $item["speed"] = 1.0;
                                }
                                if ($item["category_id"] == 15) {
                                    $item["speed"] = 1.0;
                                }
                                ?>

                                <!-- Display the item information in a table row. 
                                For damage, speed, and defence, if the value is null (e.g. not applicable for that item), display a dash instead. -->
                                <tr>

                                    <td><?= htmlspecialchars($item["name"]) ?></td>

                                    <!-- Damage (weapons only) -->
                                    <td>
                                        <?= $item["damage"] !== null ? $item["damage"] : "—" ?>
                                    </td>

                                    <!-- Speed (weapons only) -->
                                    <td>
                                        <?= $item["speed"] !== null ? $item["speed"] : "—" ?>
                                    </td>

                                    <!-- Defence (armour only) -->
                                    <td>
                                        <?= $item["defence"] !== null ? $item["defence"] : "—" ?>
                                    </td>

                                    <td><?= $item["weight"] ?></td>
                                    <td><?= $item["gold_value"] ?></td>

                                    <!-- Category -->
                                    <td><?= $categories[$item["category_id"]] ?? "Unknown" ?></td>

                                    <!-- Classification (Abilities) -->
                                    <td><?= $classifications[$item["classification_id"]] ?? "Unknown" ?></td>

                                    <!-- Perk -->
                                    <td><?= $perks[$item["perk_id"]] ?? "—" ?></td>

                                    <!-- Upgrade Material -->
                                    <td><?= $upgrades[$item["item_upgrade"]] ?? "—" ?></td>

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
