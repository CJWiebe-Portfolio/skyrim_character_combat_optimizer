<?php

/**
 * File: inventory.php
 * Author: Cygnus J. Wiebe
 * Date: April 2026
 * Project: Skyrim Character Combat Optimization System
 * Course: INFS 657: Data Design and Development - McGill University
 *
 * Description:
 * Allows a User/Admin to read, update, create, and delete items from their selected characters.
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
$pageTitle = "Inventory Management";
?>

<!-- ===================== GENERAL HEADER AND NAVBAR ===================== -->
<?php include '../page_formatting/header.php'; ?>
<?php include '../page_formatting/navbar.php'; ?>

<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

/* =========================
   AUTH CHECK
   ========================= */

if (!isset($_SESSION['account_id'])) {
    header("Location: ../login/login.php");
    exit();
}

/* =========================
   GET CHARACTER
   ========================= */

$character_id = $_GET['character_id'] ?? null;

if (!$character_id) {
    die("No character selected.");
}

/* =========================
   GET CHARACTER NAME
   ========================= */

$charStmt = $conn->prepare("
    SELECT name 
    FROM `character`
    WHERE character_id = :cid AND account_id = :aid
");

$charStmt->execute([
    ':cid' => $character_id,
    ':aid' => $_SESSION['account_id']
]);

$character = $charStmt->fetch(PDO::FETCH_ASSOC);

if (!$character) {
    die("Character not found or access denied.");
}

/* =========================
   ITEM ACTIONS
   ========================= */

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {

    $item_id = $_POST['item_id'] ?? null;

    if ($item_id) {

        // ➕ INCREASE
        if ($_POST['action'] === 'increase') {
            $stmt = $conn->prepare("
                UPDATE inventory_item
                SET quantity = quantity + 1
                WHERE item_id = :iid AND character_id = :cid
            ");
            $stmt->execute([
                ':iid' => $item_id,
                ':cid' => $character_id
            ]);
        }

        // ➖ DECREASE (auto delete at 0)
        if ($_POST['action'] === 'decrease') {

            $check = $conn->prepare("
                SELECT quantity 
                FROM inventory_item
                WHERE item_id = :iid AND character_id = :cid
            ");

            $check->execute([
                ':iid' => $item_id,
                ':cid' => $character_id
            ]);

            $row = $check->fetch(PDO::FETCH_ASSOC);

            if ($row) {
                if ($row['quantity'] > 1) {
                    $stmt = $conn->prepare("
                        UPDATE inventory_item
                        SET quantity = quantity - 1
                        WHERE item_id = :iid AND character_id = :cid
                    ");
                    $stmt->execute([
                        ':iid' => $item_id,
                        ':cid' => $character_id
                    ]);
                } else {
                    $stmt = $conn->prepare("
                        DELETE FROM inventory_item
                        WHERE item_id = :iid AND character_id = :cid
                    ");
                    $stmt->execute([
                        ':iid' => $item_id,
                        ':cid' => $character_id
                    ]);
                }
            }
        }

        // 🗑 DELETE
        if ($_POST['action'] === 'delete') {
            $stmt = $conn->prepare("
                DELETE FROM inventory_item
                WHERE item_id = :iid AND character_id = :cid
            ");
            $stmt->execute([
                ':iid' => $item_id,
                ':cid' => $character_id
            ]);
        }
    }
}

/* =========================
   ADD ITEM
   ========================= */

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['item_id']) && !isset($_POST['action'])) {

    $item_id  = $_POST['item_id'];
    $quantity = $_POST['quantity'] ?? 1;

    $check = $conn->prepare("
        SELECT quantity 
        FROM inventory_item
        WHERE item_id = :iid AND character_id = :cid
    ");

    $check->execute([
        ':iid' => $item_id,
        ':cid' => $character_id
    ]);

    $existing = $check->fetch(PDO::FETCH_ASSOC);

    if ($existing) {

        $update = $conn->prepare("
            UPDATE inventory_item
            SET quantity = quantity + :qty
            WHERE item_id = :iid AND character_id = :cid
        ");

        $update->execute([
            ':qty' => $quantity,
            ':iid' => $item_id,
            ':cid' => $character_id
        ]);
    } else {

        $insert = $conn->prepare("
            INSERT INTO inventory_item (character_id, item_id, quantity)
            VALUES (:cid, :iid, :qty)
        ");

        $insert->execute([
            ':cid' => $character_id,
            ':iid' => $item_id,
            ':qty' => $quantity
        ]);
    }
}

/* =========================
   FETCH ITEMS
   ========================= */

$items = $conn->query("
    SELECT item_id, name
    FROM item
    ORDER BY name ASC
")->fetchAll(PDO::FETCH_ASSOC);

/* =========================
   FETCH INVENTORY (FULL ATTRIBUTES)
   ========================= */

$stmt = $conn->prepare("
    SELECT 
        ti.item_id,
        ti.quantity,
        i.name,
        i.damage,
        i.speed,
        i.defence,
        i.weight,
        i.gold_value,
        i.category_id,
        i.classification_id,
        i.perk_id,
        i.item_upgrade
    FROM inventory_item ti
    JOIN item i ON ti.item_id = i.item_id
    WHERE ti.character_id = :cid
");

$stmt->execute([
    ':cid' => $character_id
]);

$inventory = $stmt->fetchAll(PDO::FETCH_ASSOC);

/* =========================
   CATEGORY MAPPING
   ========================= */
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


/* =========================
   CLASSIFICATION (ABILITIES)
   ========================= */


$classifications = [
    1 => "Light Armour",
    2 => "Heavy Armour",
    3 => "One-Handed",
    4 => "Two-Handed",
    5 => "Archery"
];


/* =========================
   PERKS
   ========================= */


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


/* =========================
   UPGRADE MATERIALS
   ========================= */


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
<!DOCTYPE HTML>
<html lang="en">

<body>
    <!-- This section displays the character's name and a back button to return to the character list. -->
    <div class="d-flex flex-column min-vh-100">
        <div class="container py-5 mt-1 flex-grow-1">
            <div class="main-container p-4">
                <div class="main-container p-5">
                    <div class="section-title">
                        <h1 class="section-title title-main text-center">🎒 <?= htmlspecialchars($character['name']) ?>'s Inventory 🎒</h1>
                        <h5 class="text-muted-custom text-center">You can manage your character's inventory from here by adding items or managing the quantity of existing ones, and deleting items as needed.</h5>
                        <br>
                        <a href="<?= BASE_URL ?>/my_character/characters.php" class="btn btn-primary text-lg">
                            Back to My Characters
                        </a>
                    </div>
                    <br>
                    <!-- ADD ITEM FORM -->
                    <div class="card-body">
                        <form method="POST" class="row mb-4 align-items-end skyrim-filter col-md-8">
                            <div class="col-md-5">
                                <select name="item_id" class="form-select">
                                    <?php foreach ($items as $item): ?>
                                        <option value="<?= $item['item_id'] ?>">
                                            <?= htmlspecialchars($item['name']) ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <input type="number" name="quantity" value="1" min="1" class="form-control">
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-success w-100">Add Item</button>
                            </div>
                        </form>
                    </div>
                    <!-- INVENTORY TABLE -->
                    <div class="table-responsive">
                        <table class="table-skyrim">
                            <thead>
                                <tr>
                                    <th>Item</th>
                                    <th>Damage</th>
                                    <th>Speed</th>
                                    <th>Defence</th>
                                    <th>Weight</th>
                                    <th>Gold</th>
                                    <th>Category</th>
                                    <th>Class</th>
                                    <th>Perk</th>
                                    <th>Upgrade</th>
                                    <th>Qty</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- If the inventory is empty, show a message. Otherwise, display each item with its attributes and action buttons. -->
                                <?php if (empty($inventory)): ?>
                                    <tr>
                                        <td colspan="11">No items in inventory.</td>
                                    </tr>
                                <?php else: ?>
                                    <?php foreach ($inventory as $item): ?>

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
                                        <!-- Display each item in the inventory with its attributes and action buttons. -->
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
                                            <td>
                                                <div class="d-flex justify-content-center align-items-center gap-2">

                                                    <span class="form-label text-lg"><?= $item['quantity'] ?></span>
                                                    <br>
                                                    <!-- ➖ -->
                                                    <form method="POST">
                                                        <input type="hidden" name="item_id" value="<?= $item['item_id'] ?>">
                                                        <input type="hidden" name="action" value="decrease">
                                                        <button class="btn btn-sm btn-outline-warning text-m">➖</button>
                                                    </form>

                                                    <!-- ➕ -->
                                                    <form method="POST">
                                                        <input type="hidden" name="item_id" value="<?= $item['item_id'] ?>">
                                                        <input type="hidden" name="action" value="increase">
                                                        <button class="btn btn-sm btn-outline-success text-m">➕</button>
                                                    </form>

                                                    <!-- 🗑 -->
                                                    <form method="POST">
                                                        <input type="hidden" name="item_id" value="<?= $item['item_id'] ?>">
                                                        <input type="hidden" name="action" value="delete">
                                                        <button class="btn btn-sm btn-outline-danger text-m"
                                                            onclick="return confirm('Delete item?');">
                                                            🗑
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </tbody>
                        </table>
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