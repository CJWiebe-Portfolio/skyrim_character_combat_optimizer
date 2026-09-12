-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 25, 2026 at 12:15 AM
-- Server version: 5.7.24
-- PHP Version: 8.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `skyrim_combat-optimization`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `account_id` int(11) NOT NULL,
  `first_name` varchar(25) NOT NULL,
  `last_name` varchar(25) NOT NULL,
  `email` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` char(6) NOT NULL DEFAULT 'user' COMMENT 'Adds the role for each account.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`account_id`, `first_name`, `last_name`, `email`, `date`, `password`, `role`) VALUES
(20, 'test', 'test', 'test@test.test', '2026-04-01', '$2y$10$sm6VITBCMVN7xrXRw2DsLeUH2o2rT3k7uX9DgUUIpb7ocfWBFgNS2', 'user'),
(21, 'Mary', 'Joe', 'fake@gmail.ca', '2026-04-01', '$2y$10$lM4ub5Dis2BtjxihONy1ZecVWif.zcd0Zfyh6wTw1grAWoSITRMHq', 'user'),
(22, 'John', 'Doe', 'john.doe@gmail.ca', '2026-04-13', '$2y$10$sT.VaxvJvPLJrSShxwpDAuoAF0nGdfDiUPIl1dEP0xBk8zc0l3kOW', 'user');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_id`, `category_name`) VALUES
(16, 'Arrow'),
(10, 'Battleaxe'),
(17, 'Bolt'),
(4, 'Boots'),
(13, 'Bow'),
(14, 'Crossbow'),
(2, 'Cuirass'),
(7, 'Dagger'),
(3, 'Gauntlets'),
(11, 'Greatsword'),
(1, 'Helmet'),
(9, 'Mace'),
(5, 'Shield'),
(15, 'Silverware'),
(6, 'Sword'),
(8, 'War Axe'),
(12, 'Warhammer');

-- --------------------------------------------------------

--
-- Table structure for table `character`
--

CREATE TABLE `character` (
  `character_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `race_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `character_number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `character`
--

INSERT INTO `character` (`character_id`, `account_id`, `race_id`, `name`, `character_number`) VALUES
(23, 20, 1, 'test1', 1),
(24, 20, 9, 'Orc-Flesh', 2),
(25, 20, 10, 'Altair', 3),
(26, 21, 7, 'Rose', 1),
(27, 21, 3, 'Legless', 2),
(28, 22, 7, 'Whiskers', 1);

-- --------------------------------------------------------

--
-- Table structure for table `character_skill`
--

CREATE TABLE `character_skill` (
  `character_id` int(11) NOT NULL,
  `skill_id` int(11) NOT NULL,
  `skill_level` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `classification`
--

CREATE TABLE `classification` (
  `classification_id` int(11) NOT NULL,
  `classification_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `classification`
--

INSERT INTO `classification` (`classification_id`, `classification_name`) VALUES
(5, 'Archery'),
(2, 'Heavy Armor'),
(1, 'Light Armor'),
(3, 'One-Handed'),
(4, 'Two-Handed');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_item`
--

CREATE TABLE `inventory_item` (
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT '1',
  `inventory_item_id` int(11) NOT NULL,
  `character_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `inventory_item`
--

INSERT INTO `inventory_item` (`item_id`, `quantity`, `inventory_item_id`, `character_id`) VALUES
(83, 3, 40, 23),
(143, 4, 41, 23),
(26, 2, 42, 23),
(456, 2, 43, 23),
(276, 1, 44, 24),
(361, 3, 45, 25),
(70, 1, 46, 25),
(127, 1, 47, 25),
(9, 1, 48, 25),
(117, 1, 49, 26),
(231, 12, 50, 26),
(37, 5, 51, 26),
(457, 1, 52, 26),
(125, 1, 54, 27),
(358, 1, 55, 27),
(31, 1, 56, 27),
(89, 1, 57, 27),
(333, 1, 58, 28),
(100, 1, 59, 28),
(230, 6, 60, 28),
(461, 11, 63, 30),
(481, 3, 65, 31),
(539, 1, 66, 32);

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `item_id` int(11) NOT NULL COMMENT 'item_id',
  `name` varchar(100) NOT NULL,
  `item_type` binary(1) DEFAULT NULL COMMENT '1=Weapons / 0=Armour',
  `weight` decimal(6,2) DEFAULT NULL,
  `gold_value` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `classification_id` int(11) DEFAULT NULL,
  `perk_id` int(11) DEFAULT NULL COMMENT 'Item''s Perk',
  `item_upgrade` int(11) DEFAULT NULL COMMENT 'Item''s Upgrade',
  `defence` int(10) DEFAULT NULL COMMENT 'Defence of Armour',
  `damage` int(10) DEFAULT NULL COMMENT 'Damage of Weapons',
  `speed` int(10) DEFAULT NULL COMMENT 'Speed of Weapons'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`item_id`, `name`, `item_type`, `weight`, `gold_value`, `category_id`, `classification_id`, `perk_id`, `item_upgrade`, `defence`, `damage`, `speed`) VALUES
(1, 'Ahzidal\'s Gauntlets of Warding DR', 0x30, '6.00', 1750, 3, 2, 5, 2, 14, NULL, NULL),
(2, 'Ancient Nord Gauntlets', 0x30, '4.00', 25, 3, 2, 8, 1, 10, NULL, NULL),
(3, 'Blades Gauntlets', 0x30, '8.00', 85, 3, 2, NULL, 2, 13, NULL, NULL),
(4, 'Bonemold Gauntlets DR', 0x30, '3.50', 60, 3, 2, 1, 17, 12, NULL, NULL),
(5, 'Chitin Heavy Gauntlets DR', 0x30, '5.00', 135, 3, 2, 2, 12, 14, NULL, NULL),
(6, 'Daedric Gauntlets', 0x30, '6.00', 625, 3, 2, 8, 5, 18, NULL, NULL),
(7, 'Dawnguard Heavy Gauntlets DG', 0x30, '7.00', 85, 3, 2, 5, 2, 13, NULL, NULL),
(8, 'Dragonplate Gauntlets', 0x30, '8.00', 425, 3, 2, 9, 10, 17, NULL, NULL),
(9, 'Dwarven Gauntlets', 0x30, '8.00', 85, 3, 2, 3, 6, 13, NULL, NULL),
(10, 'Ebony Gauntlets', 0x30, '7.00', 225, 3, 2, 7, 5, 16, NULL, NULL),
(11, 'Falmer Gauntlets', 0x30, '4.00', 55, 3, 2, 10, 13, 12, NULL, NULL),
(12, 'Falmer Hardened Gauntlets DG', 0x30, '7.00', 60, 3, 2, 5, 13, 13, NULL, NULL),
(13, 'Falmer Heavy Gauntlets DG', 0x30, '6.00', 225, 3, 2, 5, 13, 16, NULL, NULL),
(14, 'Imperial Bracers', 0x30, '4.00', 15, 3, 2, NULL, 2, 11, NULL, NULL),
(15, 'Improved Bonemold Gauntlets DR', 0x30, '7.00', 60, 3, 2, 1, 17, 13, NULL, NULL),
(16, 'Iron Gauntlets', 0x30, '5.00', 25, 3, 2, NULL, 1, 11, NULL, NULL),
(17, 'Ironhand Gauntlets', 0x30, '4.00', 444, 3, 2, NULL, 1, 12, NULL, NULL),
(18, 'Nordic Carved Gauntlets DR', 0x30, '6.00', 220, 3, 2, 5, 7, 15, NULL, NULL),
(19, 'Orcish Gauntlets', 0x30, '7.00', 200, 3, 2, 4, 4, 15, NULL, NULL),
(20, 'Stalhrim Gauntlets DR', 0x30, '7.00', 450, 3, 2, 7, 14, 17, NULL, NULL),
(21, 'Steel Imperial Gauntlets', 0x30, '4.00', 55, 3, 2, 1, 2, 12, NULL, NULL),
(22, 'Steel Nordic Gauntlets', 0x30, '4.00', 55, 3, 2, 1, 2, 12, NULL, NULL),
(23, 'Steel Plate Gauntlets', 0x30, '6.00', 125, 3, 2, 5, 3, 14, NULL, NULL),
(24, 'The Forgemaster\'s Fingers', 0x30, '5.00', 394, 3, 2, NULL, 1, 11, NULL, NULL),
(25, 'Wolf Gauntlets', 0x30, '4.00', 11, 3, 2, 1, 2, 12, NULL, NULL),
(26, 'Ancient Falmer Gauntlets DG', 0x30, '2.00', 190, 3, 1, 2, 8, 11, NULL, NULL),
(27, 'Ancient Shrouded Gloves', 0x30, '1.00', 175, 3, 1, NULL, 15, 12, NULL, NULL),
(28, 'Blackguard\'s Gloves DR', 0x30, '2.00', 778, 3, 1, NULL, 15, 8, NULL, NULL),
(29, 'Chitin Bracers DR', 0x30, '2.00', 50, 3, 1, 2, 12, 9, NULL, NULL),
(30, 'Cultist Gloves DR', 0x30, '1.50', 30, 3, 1, NULL, 15, 7, NULL, NULL),
(31, 'Dawnguard Gauntlets DG', 0x30, '1.50', 40, 3, 1, 5, 2, 8, NULL, NULL),
(32, 'Deathbrand Gauntlets DR', 0x30, '2.00', 3987, 3, 1, 7, 14, 12, NULL, NULL),
(33, 'Dragonscale Gauntlets', 0x30, '3.00', 300, 3, 1, 9, 11, 12, NULL, NULL),
(34, 'Elven Gauntlets', 0x30, '1.00', 45, 3, 1, 2, 8, 9, NULL, NULL),
(35, 'Elven Light Gauntlets', 0x30, '1.00', 25, 3, 1, 2, 8, 8, NULL, NULL),
(36, 'Forsworn Gauntlets', 0x30, '2.00', 20, 3, 1, NULL, 15, 7, NULL, NULL),
(37, 'Fur Bracers', 0x30, '1.00', 10, 3, 1, NULL, 15, 6, NULL, NULL),
(38, 'Fur Gauntlets', 0x30, '2.00', 5, 3, 1, NULL, 15, 5, NULL, NULL),
(39, 'Gauntlets of the Old Gods', 0x30, '0.50', 592, 3, 1, NULL, 15, 7, NULL, NULL),
(40, 'Gilded Wristguards', 0x30, '0.50', 21, 3, 1, NULL, NULL, 7, NULL, NULL),
(41, 'Glass Gauntlets', 0x30, '2.00', 190, 3, 1, 6, 9, 11, NULL, NULL),
(42, 'Gloves of the Pugilist', 0x30, '2.00', 194, 3, 1, NULL, 15, 5, NULL, NULL),
(43, 'Guild Master\'s Gloves', 0x30, '2.00', 599, 3, 1, NULL, 15, 11, NULL, NULL),
(44, 'Hide Bracers', 0x30, '1.00', 10, 3, 1, NULL, 15, 5, NULL, NULL),
(45, 'Imperial Light Bracers', 0x30, '1.00', 15, 3, 1, NULL, 2, 7, NULL, NULL),
(46, 'Leather Bracers', 0x30, '2.00', 25, 3, 1, NULL, 15, 7, NULL, NULL),
(47, 'Linwe\'s Gloves', 0x30, '2.00', 483, 3, 1, NULL, 15, 11, NULL, NULL),
(48, 'Miraak\'s Gloves DR', 0x30, '1.50', 30, 3, 1, NULL, NULL, 7, NULL, NULL),
(49, 'Morag Tong Bracers DR', 0x30, '2.00', 25, 3, 1, 5, 15, 7, NULL, NULL),
(50, 'Nightingale Gloves', 0x30, '2.00', 1924, 3, 1, NULL, 16, 10, NULL, NULL),
(51, 'Penitus Oculatus Bracers', 0x30, '1.00', 15, 3, 1, NULL, 15, 6, NULL, NULL),
(52, 'Scaled Bracers', 0x30, '2.00', 70, 3, 1, 5, 3, 9, NULL, NULL),
(53, 'Shrouded Gloves', 0x30, '2.00', 125, 3, 1, NULL, 15, 8, NULL, NULL),
(54, 'Skaal Gloves DR', 0x30, '1.50', 30, 3, 1, NULL, NULL, 7, NULL, NULL),
(55, 'Stalhrim Light Bracers DR', 0x30, '2.00', 215, 3, 1, 7, 14, 12, NULL, NULL),
(56, 'Stormcloak Officer Bracers', 0x30, '2.00', 7, 3, 1, NULL, 15, 7, NULL, NULL),
(57, 'Thieves Guild Gloves', 0x30, '1.00', 222, 3, 1, NULL, 15, 9, NULL, NULL),
(58, 'Tumblerbane Gloves', 0x30, '2.00', 325, 3, 1, NULL, NULL, 7, NULL, NULL),
(59, 'Ulfric\'s Bracers', 0x30, '0.50', 25, 3, 1, NULL, NULL, 8, NULL, NULL),
(60, 'Vampire Gauntlets DG', 0x30, '1.50', 25, 3, 1, 5, 15, 8, NULL, NULL),
(61, 'Worn Shrouded Gloves', 0x30, '2.00', 50, 3, 1, NULL, NULL, 4, NULL, NULL),
(62, 'Ahzidal\'s Boots of Waterwalking DR', 0x30, '9.00', 1125, 4, 2, 5, 2, 14, NULL, NULL),
(63, 'Ancient Nord Boots', 0x30, '5.00', 25, 4, 2, 8, 1, 10, NULL, NULL),
(64, 'Blades Boots', 0x30, '10.00', 85, 4, 2, NULL, 2, 13, NULL, NULL),
(65, 'Bonemold Boots DR', 0x30, '7.00', 60, 4, 2, 1, 17, 12, NULL, NULL),
(66, 'Chitin Heavy Boots DR', 0x30, '6.00', 135, 4, 2, 2, 12, 14, NULL, NULL),
(67, 'Daedric Boots', 0x30, '10.00', 625, 4, 2, 8, 5, 18, NULL, NULL),
(68, 'Dawnguard Heavy Boots DG', 0x30, '9.00', 85, 4, 2, 5, 2, 13, NULL, NULL),
(69, 'Dragonplate Boots', 0x30, '8.00', 425, 4, 2, 9, 10, 17, NULL, NULL),
(70, 'Dwarven Boots', 0x30, '10.00', 85, 4, 2, 3, 6, 13, NULL, NULL),
(71, 'Ebony Boots', 0x30, '7.00', 275, 4, 2, 7, 5, 16, NULL, NULL),
(72, 'Falmer Boots', 0x30, '4.00', 55, 4, 2, 10, 13, 12, NULL, NULL),
(73, 'Falmer Hardened Boots DG', 0x30, '8.00', 50, 4, 2, 5, 13, 13, NULL, NULL),
(74, 'Falmer Heavy Boots DG', 0x30, '6.00', 225, 4, 2, 5, 13, 16, NULL, NULL),
(75, 'Imperial Boots', 0x30, '8.00', 20, 4, 2, NULL, 2, 11, NULL, NULL),
(76, 'Improved Bonemold Boots DR', 0x30, '9.00', 60, 4, 2, 1, 17, 13, NULL, NULL),
(77, 'Iron Boots', 0x30, '6.00', 25, 4, 2, NULL, 1, 10, NULL, NULL),
(78, 'Nordic Carved Boots DR', 0x30, '6.00', 220, 4, 2, 5, 7, 15, NULL, NULL),
(79, 'Orcish Boots', 0x30, '7.00', 200, 4, 2, 4, 4, 15, NULL, NULL),
(80, 'Stalhrim Boots DR', 0x30, '7.00', 450, 4, 2, 7, 14, 17, NULL, NULL),
(81, 'Steel Shin Boots', 0x30, '8.00', 55, 4, 2, 1, 2, 12, NULL, NULL),
(82, 'Steel Cuffed 4Boots', 0x30, '8.00', 55, 4, 2, 1, 2, 12, NULL, NULL),
(83, 'Ancient Falmer Boots DG', 0x30, '2.00', 190, 4, 1, 2, 8, 11, NULL, NULL),
(84, 'Ancient Shrouded 4', 0x30, '0.50', 355, 4, 1, NULL, 15, 12, NULL, NULL),
(85, 'Blackguard\'s Boots DR', 0x30, '2.00', 836, 4, 1, NULL, 15, 13, NULL, NULL),
(86, 'Boots of the Old Gods', 0x30, '1.50', 1104, 4, 1, NULL, 15, 7, NULL, NULL),
(87, 'Chitin Boots DR', 0x30, '1.00', 50, 4, 1, 2, 12, 9, NULL, NULL),
(88, 'Dawnguard Boots DG', 0x30, '1.50', 25, 4, 1, 5, 2, 8, NULL, NULL),
(89, 'Deathbrand Boots DR', 0x30, '2.00', 2416, 4, 1, 7, 14, 12, NULL, NULL),
(90, 'Dragonscale Boots', 0x30, '3.00', 300, 4, 1, 9, 11, 12, NULL, NULL),
(91, 'Elven Boots', 0x30, '1.00', 45, 4, 1, 2, 8, 9, NULL, NULL),
(92, 'Elven Light Boots', 0x30, '1.00', 23, 4, 1, 2, 8, 8, NULL, NULL),
(93, 'Forsworn Boots', 0x30, '2.00', 20, 4, 1, NULL, 15, 8, NULL, NULL),
(94, 'Fur Boots', 0x30, '2.00', 5, 4, 1, NULL, 15, 5, NULL, NULL),
(95, 'Fur Shoes', 0x30, '2.00', 4, 4, 1, NULL, 15, 6, NULL, NULL),
(96, 'Glass Boots', 0x30, '2.00', 190, 4, 1, 6, 9, 11, NULL, NULL),
(97, 'Guild Master\'s Boots', 0x30, '2.00', 649, 4, 1, NULL, 15, 11, NULL, NULL),
(98, 'Hide Boots', 0x30, '1.00', 10, 4, 1, NULL, 15, 5, NULL, NULL),
(99, 'Imperial Light Boots', 0x30, '3.00', 15, 4, 1, NULL, 2, 7, NULL, NULL),
(100, 'Linwe\'s Boots', 0x30, '2.00', 837, 4, 1, NULL, 15, 11, NULL, NULL),
(101, 'Leather Boots', 0x30, '2.00', 25, 4, 1, NULL, 15, 7, NULL, NULL),
(102, 'Miraak\'s Boots DR', 0x30, '2.00', 25, 4, 1, NULL, NULL, 11, NULL, NULL),
(103, 'Morag Tong Boots DR', 0x30, '2.00', 35, 4, 1, 5, 15, 8, NULL, NULL),
(104, 'Movarth\'s Boots', 0x30, '1.00', 792, 4, 1, NULL, NULL, 5, NULL, NULL),
(105, 'Nightingale Boots', 0x30, '2.00', 5434, 4, 1, NULL, 16, 10, NULL, NULL),
(106, 'Penitus Oculatus Boots', 0x30, '1.00', 15, 4, 1, NULL, 15, 6, NULL, NULL),
(107, 'Predator\'s Grace', 0x30, '1.00', 117, 4, 1, NULL, 1, 5, NULL, NULL),
(108, 'Scaled Boots', 0x30, '2.00', 70, 4, 1, 5, 3, 9, NULL, NULL),
(109, 'Shrouded Boots', 0x30, '2.00', 305, 4, 1, NULL, 15, 8, NULL, NULL),
(110, 'Skaal Boots DR', 0x30, '1.50', 30, 4, 1, NULL, NULL, 7, NULL, NULL),
(111, 'Stalhrim Light Boots DR', 0x30, '2.00', 215, 4, 1, 7, 14, 12, NULL, NULL),
(112, 'Stormcloak Officer Boots', 0x30, '2.00', 7, 4, 1, NULL, 15, 7, NULL, NULL),
(113, 'Thieves Guild Boots', 0x30, '1.50', 241, 4, 1, NULL, 15, 9, NULL, NULL),
(114, 'Vampire Boots DG', 0x30, '2.00', 25, 4, 1, 5, 15, 7, NULL, NULL),
(115, 'Worn Shrouded Boots', 0x30, '2.00', 45, 4, 1, NULL, NULL, 3, NULL, NULL),
(116, 'Ahzidal\'s Armor of Retribution DR', 0x30, '38.00', 2730, 2, 2, 5, 2, 40, NULL, NULL),
(117, 'Ancient Nord Armor', 0x30, '28.00', 125, 2, 2, 8, 1, 25, NULL, NULL),
(118, 'Banded Iron Armor', 0x30, '35.00', 200, 2, 2, NULL, 3, 28, NULL, NULL),
(119, 'Blades Armor', 0x30, '45.00', 400, 2, 2, NULL, 2, 44, NULL, NULL),
(120, 'Bonemold Armor DR', 0x30, '34.00', 290, 2, 2, 1, 17, 32, NULL, NULL),
(121, 'Bonemold Guard Armor DR', 0x30, '34.00', 290, 2, 2, 1, 17, 32, NULL, NULL),
(122, 'Bonemold Pauldron Armor DR', 0x30, '34.00', 290, 2, 2, 1, 17, 32, NULL, NULL),
(123, 'Chitin Heavy Armor DR', 0x30, '35.00', 650, 2, 2, 2, 12, 40, NULL, NULL),
(124, 'Daedric Armor', 0x30, '50.00', 3200, 2, 2, 8, 5, 49, NULL, NULL),
(125, 'Dawnguard Heavy Armor DG', 0x30, '42.00', 425, 2, 2, 5, 2, 34, NULL, NULL),
(126, 'Dragonplate Armor', 0x30, '40.00', 2125, 2, 2, 9, 10, 46, NULL, NULL),
(127, 'Dwarven Armor', 0x30, '45.00', 400, 2, 2, 3, 6, 34, NULL, NULL),
(128, 'Ebony Armor', 0x30, '38.00', 1500, 2, 2, 7, 5, 43, NULL, NULL),
(129, 'Ebony Mail', 0x30, '28.00', 5000, 2, 2, 7, 5, 45, NULL, NULL),
(130, 'Falmer Hardened Armor DG', 0x30, '40.00', 250, 2, 2, 5, 13, 34, NULL, NULL),
(131, 'Falmer Heavy Armor DG', 0x30, '35.00', 1200, 2, 2, 5, 13, 43, NULL, NULL),
(132, 'Falmer Armor', 0x30, '20.00', 275, 2, 2, 10, 13, 31, NULL, NULL),
(133, 'General Tullius\' Armor', 0x30, '18.00', 65, 2, 2, NULL, 2, 31, NULL, NULL),
(134, 'Imperial Armor', 0x30, '35.00', 100, 2, 2, 1, 2, 25, NULL, NULL),
(135, 'Improved Bonemold Armor DR', 0x30, '43.00', 290, 2, 2, 1, 17, 35, NULL, NULL),
(136, 'Iron Armor', 0x30, '30.00', 125, 2, 2, NULL, 1, 25, NULL, NULL),
(137, 'Nordic Carved Armor DR', 0x30, '37.00', 1600, 2, 2, 5, 7, 43, NULL, NULL),
(138, 'Orcish Armor', 0x30, '35.00', 1000, 2, 2, 4, 4, 40, NULL, NULL),
(139, 'Stalhrim Armor DR', 0x30, '38.00', 2200, 2, 2, 7, 14, 46, NULL, NULL),
(140, 'Steel Armor', 0x30, '35.00', 275, 2, 2, 1, 2, 31, NULL, NULL),
(141, 'Steel Plate Armor', 0x30, '38.00', 625, 2, 2, 5, 3, 40, NULL, NULL),
(142, 'Wolf Armor', 0x30, '20.00', 55, 2, 2, 1, 2, 31, NULL, NULL),
(143, 'Ancient Falmer Cuirass DG', 0x30, '7.00', 900, 2, 1, 2, 8, 38, NULL, NULL),
(144, 'Ancient Shrouded Armor', 0x30, '5.00', 617, 2, 1, NULL, 15, 33, NULL, NULL),
(145, 'Armor of the Old Gods', 0x30, '3.00', 661, 2, 1, NULL, 15, 24, NULL, NULL),
(146, 'Blackguard\'s Armor DR', 0x30, '7.00', 2079, 2, 1, NULL, 15, 33, NULL, NULL),
(147, 'Chitin Armor DR', 0x30, '4.00', 240, 2, 1, 2, 12, 30, NULL, NULL),
(148, 'Dawnguard Armor DG', 0x30, '6.00', 220, 2, 1, 5, 2, 29, NULL, NULL),
(149, 'Deathbrand Armor DR', 0x30, '7.00', 2433, 2, 1, 7, 14, 39, NULL, NULL),
(150, 'Dragonscale Armor', 0x30, '10.00', 1500, 2, 1, 9, 11, 41, NULL, NULL),
(151, 'Elven Armor', 0x30, '4.00', 225, 2, 1, 2, 8, 29, NULL, NULL),
(152, 'Elven Gilded Armor', 0x30, '4.00', 550, 2, 1, 2, 8, 35, NULL, NULL),
(153, 'Elven 1', 0x30, '4.00', 125, 2, 1, 2, 8, 26, NULL, NULL),
(154, 'Falkreath Guard\'s Armor', 0x30, '6.00', 75, 2, 1, NULL, 15, 23, NULL, NULL),
(155, 'Forsworn Armor', 0x30, '6.00', 100, 2, 1, NULL, 15, 29, NULL, NULL),
(156, 'Fur Armor', 0x30, '6.00', 50, 2, 1, NULL, 15, 23, NULL, NULL),
(157, 'Glass Armor', 0x30, '7.00', 900, 2, 1, 6, 9, 38, NULL, NULL),
(158, 'Guild Master\'s Armor', 0x30, '10.00', 1779, 2, 1, NULL, 15, 38, NULL, NULL),
(159, 'Hide Armor', 0x30, '5.00', 50, 2, 1, NULL, 15, 20, NULL, NULL),
(160, 'Hjaalmarch Guard\'s Armor', 0x30, '6.00', 75, 2, 1, NULL, 15, 23, NULL, NULL),
(161, 'Imperial 1', 0x30, '6.00', 75, 2, 1, NULL, 2, 23, NULL, NULL),
(162, 'Linwe\'s Armor', 0x30, '8.00', 368, 2, 1, NULL, 15, 31, NULL, NULL),
(163, 'Leather Armor', 0x30, '6.00', 125, 2, 1, NULL, 15, 26, NULL, NULL),
(164, 'Markarth Guard\'s Armor', 0x30, '6.00', 75, 2, 1, NULL, 15, 23, NULL, NULL),
(165, 'Morag Tong Armor DR', 0x30, '5.00', 150, 2, 1, 5, 15, 26, NULL, NULL),
(166, 'Nightingale Armor', 0x30, '12.00', 1553, 2, 1, NULL, 16, 34, NULL, NULL),
(167, 'Pale Guard\'s Armor', 0x30, '6.00', 75, 2, 1, NULL, 15, 23, NULL, NULL),
(168, 'Penitus Oculatus Armor', 0x30, '6.00', 75, 2, 1, NULL, 15, 23, NULL, NULL),
(169, 'Riften Guard\'s Armor', 0x30, '6.00', 75, 2, 1, NULL, 15, 23, NULL, NULL),
(170, 'Savior\'s Hide', 0x30, '6.00', 2679, 2, 1, 7, 15, 26, NULL, NULL),
(171, 'Scaled Armor', 0x30, '6.00', 350, 2, 1, 5, 3, 32, NULL, NULL),
(172, 'Scaled Horn Armor', 0x30, '6.00', 350, 2, 1, NULL, NULL, 32, NULL, NULL),
(173, 'Shrouded Armor', 0x30, '7.00', 373, 2, 1, NULL, 15, 29, NULL, NULL),
(174, 'Skaal Coat DR', 0x30, '5.00', 100, 2, 1, NULL, NULL, 26, NULL, NULL),
(175, 'Solitude Guard\'s Armor', 0x30, '6.00', 75, 2, 1, NULL, 15, 23, NULL, NULL),
(176, 'Stalhrim Light Armor DR', 0x30, '7.00', 925, 2, 1, 7, 14, 39, NULL, NULL),
(177, 'Stormcloak Cuirass', 0x30, '8.00', 10, 2, 1, NULL, 15, 23, NULL, NULL),
(178, 'Stormcloak Officer Armor', 0x30, '8.00', 35, 2, 1, NULL, 15, 27, NULL, NULL),
(179, 'Studded Armor', 0x30, '6.00', 75, 2, 1, NULL, 1, 23, NULL, NULL),
(180, 'Studded Imperial Armor', 0x30, '6.00', 125, 2, 1, NULL, NULL, 23, NULL, NULL),
(181, 'Thieves Guild Armor', 0x30, '7.00', 665, 2, 1, NULL, 15, 33, NULL, NULL),
(182, 'Vampire Armor DG', 0x30, '5.00', 175, 2, 1, 5, 15, 25, NULL, NULL),
(183, 'Vampire Royal Armor DG', 0x30, '9.00', 250, 2, 1, 5, 15, 30, NULL, NULL),
(184, 'Whiterun Guard\'s Armor', 0x30, '6.00', 75, 2, 1, NULL, 15, 23, NULL, NULL),
(185, 'Winterhold Guard\'s Armor', 0x30, '6.00', 75, 2, 1, NULL, 15, 23, NULL, NULL),
(186, 'Worn Shrouded Armor', 0x30, '6.00', 80, 2, 1, NULL, NULL, 20, NULL, NULL),
(187, 'Ahzidal DR', 0x30, '9.00', 500, 1, 2, 8, 5, 23, NULL, NULL),
(188, 'Ahzidal\'s Helm of Vision DR', 0x30, '6.00', 1250, 1, 2, 5, 2, 19, NULL, NULL),
(189, 'Ancient Helmet of the Unburned', 0x30, '4.00', 841, 1, 2, 8, 1, 15, NULL, NULL),
(190, 'Ancient Nord Helmet', 0x30, '4.00', 60, 1, 2, 8, 1, 15, NULL, NULL),
(191, 'Blades Helmet', 0x30, '12.00', 200, 1, 2, NULL, 2, 18, NULL, NULL),
(192, 'Bonemold Helmet DR', 0x30, '4.50', 135, 1, 2, 1, 17, 17, NULL, NULL),
(193, 'Chitin Heavy Helmet DR', 0x30, '5.00', 135, 1, 2, 2, 12, 19, NULL, NULL),
(194, 'Cultist Mask DR', 0x30, '5.00', 50, 1, 2, NULL, 2, 17, NULL, NULL),
(195, 'Daedric Helmet', 0x30, '15.00', 1600, 1, 2, 8, 5, 23, NULL, NULL),
(196, 'Dawnguard Full Helmet DG', 0x30, '10.00', 220, 1, 2, 5, 2, 18, NULL, NULL),
(197, 'Dragonplate Helmet', 0x30, '8.00', 1050, 1, 2, 9, 11, 22, NULL, NULL),
(198, 'Dukaan DR', 0x30, '9.00', 500, 1, 2, 8, 5, 23, NULL, NULL),
(199, 'Dwarven Helmet', 0x30, '12.00', 200, 1, 2, 3, 6, 18, NULL, NULL),
(200, 'Ebony Helmet', 0x30, '10.00', 750, 1, 2, 7, 5, 21, NULL, NULL),
(201, 'Falmer Hardened Helm DG', 0x30, '10.00', 150, 1, 2, 5, 13, 18, NULL, NULL),
(202, 'Falmer Heavy Helm DG', 0x30, '8.00', 600, 1, 2, 5, 13, 21, NULL, NULL),
(203, 'Falmer Helmet', 0x30, '5.00', 25, 1, 2, 10, 13, 10, NULL, NULL),
(204, 'Helm of Yngol', 0x30, '8.00', 565, 1, 2, 5, 2, 21, NULL, NULL),
(205, 'Helm of Winterhold', 0x30, '5.00', 125, 1, 2, 1, 2, 17, NULL, NULL),
(206, 'Hevnoraak', 0x30, '9.00', 891, 1, 2, 8, 1, 23, NULL, NULL),
(207, 'Imperial Helmet', 0x30, '5.00', 50, 1, 2, 1, 2, 15, NULL, NULL),
(208, 'Imperial Helmet (Closed)', 0x30, '5.00', 30, 1, 2, 1, 2, 18, NULL, NULL),
(209, 'Imperial Officer\'s Helmet', 0x30, '4.00', 30, 1, 2, 1, 2, 17, NULL, NULL),
(210, 'Improved Bonemold Helmet DR', 0x30, '11.00', 135, 1, 2, 1, 17, 18, NULL, NULL),
(211, 'Iron Helmet', 0x30, '5.00', 60, 1, 2, NULL, 1, 15, NULL, NULL),
(212, 'The Jagged Crown', 0x30, '9.00', 5000, 1, 2, NULL, NULL, 23, NULL, NULL),
(213, 'Konahrik', 0x30, '7.00', 3200, 1, 2, 8, 18, 24, NULL, NULL),
(214, 'Masque of Clavicus Vile', 0x30, '7.00', 1277, 1, 2, NULL, NULL, 23, NULL, NULL),
(215, 'Miraak (Mask) [Level 1-44]', 0x30, '9.00', 618, 1, 2, NULL, NULL, 23, NULL, NULL),
(216, 'Miraak (Mask) [Level 45-59]', 0x30, '9.00', 733, 1, 2, NULL, NULL, 25, NULL, NULL),
(217, 'Miraak (Mask) [Level 60+]', 0x30, '9.00', 849, 1, 2, NULL, NULL, 27, NULL, NULL),
(218, 'Nahkriin', 0x30, '9.00', 2173, 1, 2, 8, 5, 23, NULL, NULL),
(219, 'Nordic Carved Helmet DR', 0x30, '7.00', 550, 1, 2, 5, 7, 20, NULL, NULL),
(220, 'Orcish Helmet', 0x30, '8.00', 500, 1, 2, 4, 4, 20, NULL, NULL),
(221, 'Otar', 0x30, '9.00', 1521, 1, 2, 8, 9, 23, NULL, NULL),
(222, 'Rahgot', 0x30, '9.00', 962, 1, 2, 8, 4, 23, NULL, NULL),
(223, 'Shellbug Helmet DG', 0x30, '6.00', 600, 1, 2, 5, 13, 22, NULL, NULL),
(224, 'Stalhrim Helm DR', 0x30, '7.00', 1135, 1, 2, 7, 14, 22, NULL, NULL),
(225, 'Steel Helmet', 0x30, '5.00', 125, 1, 2, 1, 2, 17, NULL, NULL),
(226, 'Steel Horned Helmet', 0x30, '5.00', 125, 1, 2, 1, 2, 17, NULL, NULL),
(227, 'Steel Plate Helmet', 0x30, '6.00', 300, 1, 2, 5, 3, 19, NULL, NULL),
(228, 'Visage of Mzund DR', 0x30, '12.00', 1542, 1, 2, 3, 6, 24, NULL, NULL),
(229, 'Vokun', 0x30, '9.00', 2182, 1, 2, 8, 2, 23, NULL, NULL),
(230, 'Wolf Helmet', 0x30, '4.00', 125, 1, 2, 1, 2, 17, NULL, NULL),
(231, 'Zahkriisos DR', 0x30, '9.00', 500, 1, 2, 8, 5, 23, NULL, NULL),
(232, 'Ancient Shrouded Cowl', 0x30, '1.00', 1199, 1, 1, NULL, 15, 15, NULL, NULL),
(233, 'Blackguard\'s Hood DR', 0x30, '2.00', 1745, 1, 1, NULL, 15, 18, NULL, NULL),
(234, 'Chitin Helmet DR', 0x30, '1.00', 125, 1, 1, 2, 12, 14, NULL, NULL),
(235, 'Dawnguard Helmet DG', 0x30, '1.50', 100, 1, 1, 5, 2, 16, NULL, NULL),
(236, 'Deathbrand Helm DR', 0x30, '2.00', 2433, 1, 1, 7, 14, 17, NULL, NULL),
(237, 'Dragonscale Helmet', 0x30, '4.00', 750, 1, 1, 9, 11, 17, NULL, NULL),
(238, 'Elven Helmet', 0x30, '1.00', 110, 1, 1, 2, 8, 14, NULL, NULL),
(239, 'Elven Light Helmet', 0x30, '1.00', 60, 1, 1, 2, 8, 14, NULL, NULL),
(240, 'Falkreath Guard\'s Helmet', 0x30, '2.00', 35, 1, 1, NULL, 1, 11, NULL, NULL),
(241, 'Forsworn Headdress', 0x30, '2.00', 50, 1, 1, NULL, 15, 14, NULL, NULL),
(242, 'Fur Helmet', 0x30, '1.00', 23, 1, 1, NULL, 15, 11, NULL, NULL),
(243, 'Glass Helmet', 0x30, '2.00', 450, 1, 1, 6, 9, 16, NULL, NULL),
(244, 'Guild Master\'s Hood', 0x30, '3.00', 1252, 1, 1, NULL, 15, 16, NULL, NULL),
(245, 'Helmet of the Old Gods', 0x30, '1.00', 345, 1, 1, NULL, 15, 12, NULL, NULL),
(246, 'Hide Helmet', 0x30, '2.00', 25, 1, 1, NULL, 15, 10, NULL, NULL),
(247, 'Hjaalmarch Guard\'s Helmet', 0x30, '2.00', 35, 1, 1, NULL, 1, 11, NULL, NULL),
(248, 'Imperial Light Helmet', 0x30, '2.00', 35, 1, 1, NULL, 2, 11, NULL, NULL),
(249, 'Krosis', 0x30, '5.00', 1615, 1, 1, 8, 1, 21, NULL, NULL),
(250, 'Leather Helmet', 0x30, '2.00', 60, 1, 1, NULL, 15, 12, NULL, NULL),
(251, 'Linwe\'s Hood', 0x30, '2.00', 563, 1, 1, NULL, 15, 16, NULL, NULL),
(252, 'Markarth Guard\'s Helmet', 0x30, '2.00', 35, 1, 1, NULL, 1, 11, NULL, NULL),
(253, 'Miraak (Mask) [Level 1-44]', 0x30, '9.00', 505, 1, 1, NULL, NULL, 23, NULL, NULL),
(254, 'Miraak (Mask) [Level 45-59]', 0x30, '9.00', 733, 1, 1, NULL, NULL, 25, NULL, NULL),
(255, 'Miraak (Mask) [Level 60+]', 0x30, '9.00', 849, 1, 1, NULL, NULL, 27, NULL, NULL),
(256, 'Morag Tong Hood DR', 0x30, '1.50', 2, 1, 1, 5, 15, 12, NULL, NULL),
(257, 'Morokei', 0x30, '4.00', 637, 1, 1, 8, 8, 5, NULL, NULL),
(258, 'Nightingale Hood', 0x30, '2.00', 969, 1, 1, NULL, 16, 15, NULL, NULL),
(259, 'Noster\'s Helmet', 0x30, '2.00', 35, 1, 1, NULL, 15, 11, NULL, NULL),
(260, 'Pale Guard\'s Helmet', 0x30, '2.00', 35, 1, 1, NULL, 1, 11, NULL, NULL),
(261, 'Penitus Oculatus Helmet', 0x30, '1.00', 35, 1, 1, NULL, 15, 11, NULL, NULL),
(262, 'Riften Guard\'s Helmet', 0x30, '2.00', 35, 1, 1, NULL, 1, 11, NULL, NULL),
(263, 'Scaled Helmet', 0x30, '2.00', 175, 1, 1, 5, 3, 14, NULL, NULL),
(264, 'Shrouded Cowl', 0x30, '2.00', 667, 1, 1, NULL, 15, 13, NULL, NULL),
(265, 'Shrouded Cowl Maskless', 0x30, '2.00', 667, 1, 1, NULL, NULL, 13, NULL, NULL),
(266, 'Solitude Guard\'s Helmet', 0x30, '2.00', 35, 1, 1, NULL, 1, 11, NULL, NULL),
(267, 'Skaal Hat DR', 0x30, '1.50', 400, 1, 1, NULL, NULL, 6, NULL, NULL),
(268, 'Stalhrim Light Helmet DR', 0x30, '2.00', 465, 1, 1, 7, 14, 17, NULL, NULL),
(269, 'Stormcloak Helmet', 0x30, '2.00', 12, 1, 1, NULL, 15, 10, NULL, NULL),
(270, 'Stormcloak Officer Helmet', 0x30, '2.00', 15, 1, 1, NULL, 15, 12, NULL, NULL),
(271, 'Thieves Guild Hood', 0x30, '1.50', 551, 1, 1, NULL, 15, 13, NULL, NULL),
(272, 'Torturer\'s Hood', 0x30, '1.00', 10, 1, 1, NULL, 15, 13, NULL, NULL),
(273, 'Volsung', 0x30, '5.00', 4611, 1, 1, 8, 3, 21, NULL, NULL),
(274, 'Winterhold Guard\'s Helmet', 0x30, '2.00', 35, 1, 1, NULL, 1, 11, NULL, NULL),
(275, 'Whiterun Guard\'s Helmet', 0x30, '2.00', 35, 1, 1, NULL, 1, 11, NULL, NULL),
(276, 'Wooden Mask', 0x30, '2.00', 51, 1, 1, NULL, NULL, 1, NULL, NULL),
(277, 'Worn Shrouded Cowl', 0x30, '2.00', 50, 1, 1, NULL, NULL, 8, NULL, NULL),
(278, 'Ancient Nord Battle Axe', 0x31, '22.00', 28, 10, 4, 1, 2, NULL, 18, NULL),
(279, 'Daedric Battleaxe', 0x31, '27.00', 2750, 10, 4, 8, 5, NULL, 25, NULL),
(280, 'Dragonbone Battleaxe ', 0x31, '30.00', 3000, 10, 4, 9, 10, NULL, 26, NULL),
(281, 'Drainblood Battleaxe', 0x31, '5.00', 266, 10, 4, NULL, NULL, NULL, 21, NULL),
(282, 'Dwarven Battleaxe', 0x31, '23.00', 300, 10, 4, 3, 6, NULL, 20, NULL),
(283, 'Ebony Battleaxe', 0x31, '26.00', 1585, 10, 4, 7, 5, NULL, 23, NULL),
(284, 'Elven Battleaxe', 0x31, '24.00', 520, 10, 4, 2, 8, NULL, 21, NULL),
(285, 'Glass Battleaxe', 0x31, '25.00', 900, 10, 4, 6, 9, NULL, 22, NULL),
(286, 'Headsman\'s Axe', 0x31, '11.00', 15, 10, 4, NULL, NULL, NULL, 17, NULL),
(287, 'Honed Ancient Nord Battle Axe', 0x31, '25.00', 50, 10, 4, 3, 2, NULL, 21, NULL),
(288, 'Iron Battleaxe', 0x31, '20.00', 55, 10, 4, NULL, 1, NULL, 16, NULL),
(289, 'Nord Hero Battle Axe', 0x31, '20.00', 300, 10, 4, 1, 2, NULL, 21, NULL),
(290, 'Nordic Battleaxe DR', 0x31, '23.00', 650, 10, 4, 5, 7, NULL, 21, NULL),
(291, 'Orcish Battleaxe', 0x31, '25.00', 165, 10, 4, 4, 4, NULL, 19, NULL),
(292, 'Skyforge Steel Battleaxe', 0x31, '21.00', 150, 10, 4, 1, 2, NULL, 21, NULL),
(293, 'Stalhrim Battleaxe ', 0x31, '25.00', 2150, 10, 4, 7, 14, NULL, 24, NULL),
(294, 'Steel Battleaxe of Fiery Souls', 0x31, '21.00', 320, 10, 4, 1, 2, NULL, 18, NULL),
(295, 'Steel Battleaxe', 0x31, '21.00', 100, 10, 4, 1, 2, NULL, 18, NULL),
(296, 'Rueful Axe', 0x31, '10.00', 1183, 10, 4, NULL, 5, NULL, 22, NULL),
(297, 'The Woodsman\'s Friend', 0x31, '20.00', 28, 10, 4, NULL, NULL, NULL, 17, NULL),
(298, 'Tsun\'s Battleaxe', 0x31, '36.00', 1000, 10, 4, NULL, NULL, NULL, 27, NULL),
(299, 'Wuuthrad', 0x31, '25.00', 2000, 10, 4, NULL, NULL, NULL, 25, NULL),
(300, 'Alessandra\'s Dagger', 0x31, '1.00', 10, 7, 3, NULL, NULL, NULL, 5, NULL),
(301, 'Blade of Woe', 0x31, '7.00', 880, 7, 3, 1, NULL, NULL, 12, NULL),
(302, 'Blade of Sacrifice', 0x31, '4.00', 144, 7, 3, NULL, 5, NULL, 10, NULL),
(303, 'Bloodthorn', 0x31, '2.50', 183, 7, 3, 1, 2, NULL, 8, NULL),
(304, 'Borvir\'s Dagger', 0x31, '4.00', 18, 7, 3, 2, 8, NULL, 8, NULL),
(305, 'Daedric Dagger', 0x31, '6.00', 500, 7, 3, 8, 5, NULL, 11, NULL),
(306, 'Dragonbone Dagger ', 0x31, '6.50', 600, 7, 3, 9, 10, NULL, 12, NULL),
(307, 'Dragon Priest Dagger', 0x31, '5.00', 9, 7, 3, NULL, NULL, NULL, 6, NULL),
(308, 'Dwarven Dagger', 0x31, '3.50', 55, 7, 3, 3, 6, NULL, 7, NULL),
(309, 'Ebony Dagger', 0x31, '5.00', 290, 7, 3, 7, 5, NULL, 10, NULL),
(310, 'Elven Dagger', 0x31, '4.00', 95, 7, 3, 2, 8, NULL, 8, NULL),
(311, 'Glass Dagger', 0x31, '4.50', 165, 7, 3, 6, 9, NULL, 9, NULL),
(312, 'Iron Dagger', 0x31, '2.00', 10, 7, 3, NULL, 1, NULL, 4, NULL),
(313, 'Kahvozein\'s Fang', 0x31, '5.00', 9, 7, 3, NULL, NULL, NULL, 6, NULL),
(314, 'Keening', 0x31, '4.00', 5, 7, 3, NULL, NULL, NULL, 8, NULL),
(315, 'Mehrunes\' Razor', 0x31, '3.00', 860, 7, 3, NULL, 5, NULL, 11, NULL),
(316, 'Nettlebane', 0x31, '10.00', 5, 7, 3, NULL, 5, NULL, 6, NULL),
(317, 'Nordic Dagger ', 0x31, '3.50', 115, 7, 3, 5, 7, NULL, 8, NULL),
(318, 'Orcish Dagger', 0x31, '3.00', 30, 7, 3, 4, 4, NULL, 6, NULL),
(319, 'Rundi\'s Dagger', 0x31, '2.50', 18, 7, 3, 1, 2, NULL, 5, NULL),
(320, 'Shiv', 0x31, '2.00', 5, 7, 3, NULL, NULL, NULL, 5, NULL),
(321, 'Skyforge Steel Dagger', 0x31, '2.50', 25, 7, 3, NULL, NULL, NULL, 8, NULL),
(322, 'Stalhrim Dagger ', 0x31, '4.50', 395, 7, 3, 7, 14, NULL, 10, NULL),
(323, 'Steel Dagger', 0x31, '2.50', 18, 7, 3, 1, 2, NULL, 5, NULL),
(324, 'Valdr\'s Lucky Dagger', 0x31, '2.50', 15, 7, 3, 1, 2, NULL, 5, NULL),
(325, 'Daedric Mace', 0x31, '20.00', 1750, 9, 3, 8, 5, NULL, 16, NULL),
(326, 'Dragonbone Mace ', 0x31, '22.00', 2000, 9, 3, 9, 10, NULL, 17, NULL),
(327, 'Dwarven Mace', 0x31, '16.00', 190, 9, 3, 3, 6, NULL, 12, NULL),
(328, 'Ebony Mace', 0x31, '19.00', 1000, 9, 3, 7, 5, NULL, 16, NULL),
(329, 'Elven Mace', 0x31, '17.00', 330, 9, 3, 2, 8, NULL, 13, NULL),
(330, 'Glass Mace', 0x31, '18.00', 575, 9, 3, 6, 9, NULL, 14, NULL),
(331, 'Horksbane ', 0x31, '14.00', 250, 9, 3, 1, 2, NULL, 10, NULL),
(332, 'Iron Mace', 0x31, '13.00', 35, 9, 3, NULL, 1, NULL, 9, NULL),
(333, 'Lunar Iron Mace (Lvl 2-3)', 0x31, '13.00', 99, 9, 3, NULL, 1, NULL, 9, NULL),
(334, 'Lunar Iron Mace (Lvl 4-5)', 0x31, '13.00', 133, 9, 3, NULL, 1, NULL, 9, NULL),
(335, 'Lunar Iron Mace (Lvl 6+)', 0x31, '13.00', 168, 9, 3, NULL, 1, NULL, 9, NULL),
(336, 'Lunar Steel Mace (Lvl 4-5)', 0x31, '14.00', 129, 9, 3, NULL, 1, NULL, 10, NULL),
(337, 'Lunar Steel Mace (Lvl 6-7)', 0x31, '14.00', 163, 9, 3, NULL, 1, NULL, 10, NULL),
(338, 'Lunar Steel Mace (Lvl 8+)', 0x31, '14.00', 198, 9, 3, NULL, 1, NULL, 10, NULL),
(339, 'Mace of Molag Bal', 0x31, '18.00', 1257, 9, 3, NULL, 5, NULL, 16, NULL),
(340, 'Nordic Mace ', 0x31, '16.00', 410, 9, 3, 5, 7, NULL, 13, NULL),
(341, 'Orcish Mace', 0x31, '15.00', 105, 9, 3, 4, 4, NULL, 11, NULL),
(342, 'Prelate\'s Mace ', 0x31, '7.00', 330, 9, 3, 2, 8, NULL, 13, NULL),
(343, 'Rusty Mace', 0x31, '13.00', 5, 9, 3, NULL, NULL, NULL, 7, NULL),
(344, 'Stalhrim Mace ', 0x31, '18.00', 1375, 9, 3, 7, 14, NULL, 16, NULL),
(345, 'Steel Mace', 0x31, '14.00', 65, 9, 3, 1, 2, NULL, 10, NULL),
(346, 'Akaviri Sword ', 0x31, '10.00', 300, 6, 3, NULL, NULL, NULL, 11, NULL),
(347, 'Amren\'s Family Sword', 0x31, '9.00', 25, 6, 3, NULL, 1, NULL, 7, NULL),
(348, 'Ancient Nord Sword', 0x31, '12.00', 13, 6, 3, 1, 2, NULL, 8, NULL),
(349, 'Blades Sword', 0x31, '10.00', 300, 6, 3, 1, 2, NULL, 11, NULL),
(350, 'Bloodscythe ', 0x31, '10.00', 1859, 6, 3, 8, 5, NULL, 13, NULL),
(351, 'Bolar\'s Oathblade', 0x31, '10.00', 1014, 6, 3, 1, 7, NULL, 11, NULL),
(352, 'Ceremonial Sword', 0x31, '12.00', 5, 6, 3, 1, 2, NULL, 8, NULL),
(353, 'Chillrend (Lv 1-10)', 0x31, '11.00', 552, 6, 3, 6, 9, NULL, 10, NULL),
(354, 'Chillrend (Lvl 11-18)', 0x31, '12.00', 635, 6, 3, 6, 9, NULL, 11, NULL),
(355, 'Chillrend (Lvl 19-26)', 0x31, '13.00', 872, 6, 3, 6, 9, NULL, 12, NULL),
(356, 'Chillrend (Lvl 27-35)', 0x31, '14.00', 846, 6, 3, 6, 9, NULL, 13, NULL),
(357, 'Chillrend (Lvl 36-45)', 0x31, '15.00', 1111, 6, 3, 6, 9, NULL, 14, NULL),
(358, 'Chillrend (Lvl 46+)', 0x31, '16.00', 1442, 6, 3, 6, 9, NULL, 15, NULL),
(359, 'Daedric Sword', 0x31, '16.00', 1250, 6, 3, 8, 5, NULL, 14, NULL),
(360, 'Dawnbreaker', 0x31, '10.00', 740, 6, 3, NULL, 5, NULL, 12, NULL),
(361, 'Dragonbane (Lvl 1-18)', 0x31, '10.00', 789, 6, 3, 1, 7, NULL, 10, NULL),
(362, 'Dragonbane (Lvl 19-26)', 0x31, '11.00', 1046, 6, 3, 1, 7, NULL, 11, NULL),
(363, 'Dragonbane (Lvl 27-35)', 0x31, '12.00', 1189, 6, 3, 1, 7, NULL, 12, NULL),
(364, 'Dragonbane (Lvl 36-45)', 0x31, '13.00', 1860, 6, 3, 1, 7, NULL, 13, NULL),
(365, 'Dragonbane (Lvl 46+)', 0x31, '14.00', 2596, 6, 3, 1, 7, NULL, 14, NULL),
(366, 'Dragonbone Sword ', 0x31, '19.00', 1500, 6, 3, 9, 10, NULL, 15, NULL),
(367, 'Drainheart Sword', 0x31, '3.00', 73, 6, 3, NULL, NULL, NULL, 11, NULL),
(368, 'Dwarven Sword', 0x31, '12.00', 135, 6, 3, 3, 6, NULL, 10, NULL),
(369, 'Ebony Sword', 0x31, '15.00', 720, 6, 3, 7, 5, NULL, 13, NULL),
(370, 'Eduj', 0x31, '9.00', 300, 6, 3, 1, 2, NULL, 11, NULL),
(371, 'Elven Sword', 0x31, '13.00', 235, 6, 3, 2, 8, NULL, 11, NULL),
(372, 'Falmer Sword', 0x31, '18.00', 67, 6, 3, NULL, 13, NULL, 10, NULL),
(373, 'Forsworn Sword', 0x31, '13.00', 70, 6, 3, 1, 2, NULL, 10, NULL),
(374, 'Gauldur Blackblade (Lvl 1-11)', 0x31, '12.00', 234, 6, 3, 3, 2, NULL, 8, NULL),
(375, 'Gauldur Blackblade (Lvl 12-18)', 0x31, '12.00', 465, 6, 3, 3, 2, NULL, 8, NULL),
(376, 'Gauldur Blackblade (Lvl 19-26)', 0x31, '15.00', 669, 6, 3, 3, 2, NULL, 11, NULL),
(377, 'Gauldur Blackblade (Lvl 27-35)', 0x31, '15.00', 975, 6, 3, 3, 2, NULL, 11, NULL),
(378, 'Gauldur Blackblade (Lvl 36+)', 0x31, '15.00', 1286, 6, 3, 3, 2, NULL, 11, NULL),
(379, 'Ghostblade', 0x31, '1.00', 300, 6, 3, NULL, 21, NULL, 8, NULL),
(380, 'Glass Sword', 0x31, '14.00', 410, 6, 3, 6, 9, NULL, 12, NULL),
(381, 'Grimsever', 0x31, '14.00', 727, 6, 3, 6, 9, NULL, 12, NULL),
(382, 'Harkon\'s Sword ', 0x31, '9.00', 1472, 6, 3, 1, 2, NULL, 8, NULL),
(383, 'Herebane\'s Courage', 0x31, '13.00', 639, 6, 3, 2, 8, NULL, 11, NULL),
(384, 'Hjalti\'s Sword', 0x31, '12.00', 13, 6, 3, NULL, NULL, NULL, 8, NULL),
(385, 'Honed Ancient Nord Sword', 0x31, '15.00', 23, 6, 3, 3, 2, NULL, 11, NULL),
(386, 'Honed Falmer Sword', 0x31, '18.00', 205, 6, 3, NULL, NULL, NULL, 12, NULL),
(387, 'Imperial Sword', 0x31, '10.00', 23, 6, 3, 1, 2, NULL, 8, NULL),
(388, 'Iron Sword', 0x31, '9.00', 25, 6, 3, NULL, 1, NULL, 7, NULL),
(389, 'Lunar Iron Sword (Lvl 2-3)', 0x31, '9.00', 89, 6, 3, NULL, 1, NULL, 7, NULL),
(390, 'Lunar Iron Sword (Lvl 4-5)', 0x31, '9.00', 123, 6, 3, NULL, 1, NULL, 7, NULL),
(391, 'Lunar Iron Sword (Lvl 6+)', 0x31, '9.00', 158, 6, 3, NULL, 1, NULL, 7, NULL),
(392, 'Lunar Steel Sword (Lvl 4-5)', 0x31, '10.00', 69, 6, 3, 1, 2, NULL, 8, NULL),
(393, 'Lunar Steel Sword (Lvl 6-7)', 0x31, '10.00', 103, 6, 3, 1, 2, NULL, 8, NULL),
(394, 'Lunar Steel Sword (Lvl 8+)', 0x31, '10.00', 138, 6, 3, 1, 2, NULL, 8, NULL),
(395, 'Miraak\'s Sword ', 0x31, '3.00', 427, 6, 3, 3, 19, NULL, 16, NULL),
(396, 'Nightingale Blade (Lvl1-18)', 0x31, '11.00', 426, 6, 3, NULL, 5, NULL, 10, NULL),
(397, 'Nightingale Blade (Lvl 19-26)', 0x31, '12.00', 851, 6, 3, NULL, 5, NULL, 11, NULL),
(398, 'Nightingale Blade (Lvl 27-35)', 0x31, '13.00', 1424, 6, 3, NULL, 5, NULL, 12, NULL),
(399, 'Nightingale Blade (Lvl 36-45)', 0x31, '14.00', 2248, 6, 3, NULL, 5, NULL, 13, NULL),
(400, 'Nightingale Blade (Lvl 46+)', 0x31, '15.00', 1665, 6, 3, NULL, 5, NULL, 14, NULL),
(401, 'Nord Hero Sword', 0x31, '9.00', 135, 6, 3, 1, 2, NULL, 11, NULL),
(402, 'Nordic Sword ', 0x31, '12.00', 290, 6, 3, 5, 7, NULL, 11, NULL),
(403, 'Orcish Sword', 0x31, '11.00', 75, 6, 3, 4, 4, NULL, 9, NULL),
(404, 'Phantom Sword', 0x31, '0.00', 0, 6, 3, NULL, NULL, NULL, 1, NULL),
(405, 'Queen Freydis\'s Sword', 0x31, '10.00', 45, 6, 3, 1, 2, NULL, 8, NULL),
(406, 'Red Eagle\'s Bane', 0x31, '15.00', 100, 6, 3, 3, 2, NULL, 11, NULL),
(407, 'Red Eagle\'s Fury', 0x31, '12.00', 97, 6, 3, 1, 2, NULL, 8, NULL),
(408, 'Scimitar', 0x31, '10.00', 5, 6, 3, 1, 2, NULL, 11, NULL),
(409, 'Silver Sword', 0x31, '7.00', 100, 6, 3, NULL, NULL, NULL, 8, NULL),
(410, 'Skyforge Steel Sword', 0x31, '10.00', 70, 6, 3, 1, 2, NULL, 11, NULL),
(411, 'Stalhrim Sword ', 0x31, '14.00', 985, 6, 3, 7, 14, NULL, 13, NULL),
(412, 'Steel Sword', 0x31, '10.00', 45, 6, 3, 1, 2, NULL, 8, NULL),
(413, 'Soulrender ', 0x31, '10.00', 1000, 6, 3, 8, 5, NULL, 13, NULL),
(414, 'The Pale Blade (Lvl 1-5)', 0x31, '12.00', 169, 6, 3, 1, 2, NULL, 8, NULL),
(415, 'The Pale Blade (Lvl 6-11)', 0x31, '12.00', 286, 6, 3, 1, 2, NULL, 8, NULL),
(416, 'The Pale Blade (Lvl 12-18)', 0x31, '15.00', 452, 6, 3, 1, 2, NULL, 11, NULL),
(417, 'The Pale Blade (Lvl 19-26)', 0x31, '15.00', 667, 6, 3, 1, 2, NULL, 11, NULL),
(418, 'The Pale Blade (Lvl 27+)', 0x31, '15.00', 914, 6, 3, 1, 2, NULL, 11, NULL),
(419, 'Vilkas\'s Sword', 0x31, '10.00', 70, 6, 3, 1, 2, NULL, 11, NULL),
(420, 'Windshear', 0x31, '10.00', 40, 6, 3, 1, 2, NULL, 11, NULL),
(421, 'Wooden Sword ', 0x31, '3.00', 25, 6, 3, NULL, 11, NULL, 2, NULL),
(422, 'Ancient Nord War Axe', 0x31, '14.00', 15, 8, 3, 1, 2, NULL, 9, NULL),
(423, 'Ancient Nordic Pickaxe ', 0x31, '10.00', 500, 8, 3, NULL, NULL, NULL, 5, NULL),
(424, 'Ceremonial Axe', 0x31, '14.00', 5, 8, 3, 1, 2, NULL, 9, NULL),
(425, 'Daedric War Axe', 0x31, '18.00', 1500, 8, 3, 8, 5, NULL, 15, NULL),
(426, 'Dawnguard Rune Axe ', 0x31, '13.00', 175, 8, 3, 1, 2, NULL, 11, NULL),
(427, 'Dawnguard War Axe ', 0x31, '13.00', 55, 8, 3, 1, 2, NULL, 11, NULL),
(428, 'Dragonbone War Axe ', 0x31, '21.00', 1700, 8, 3, 9, 10, NULL, 16, NULL),
(429, 'Dwarven War Axe', 0x31, '14.00', 165, 8, 3, 3, 6, NULL, 11, NULL),
(430, 'Ebony War Axe', 0x31, '17.00', 865, 8, 3, 7, 5, NULL, 15, NULL),
(431, 'Elven War Axe', 0x31, '15.00', 280, 8, 3, 2, 8, NULL, 12, NULL),
(432, 'Falmer War Axe', 0x31, '21.00', 82, 8, 3, NULL, 13, NULL, 11, NULL),
(433, 'Forsworn Axe', 0x31, '15.00', 90, 8, 3, 1, 2, NULL, 11, NULL),
(434, 'Ghorbash\'s Ancestral Axe', 0x31, '11.00', 30, 8, 3, NULL, 1, NULL, 8, NULL),
(435, 'Glass War Axe', 0x31, '16.00', 490, 8, 3, 6, 9, NULL, 14, NULL),
(436, 'Hoarfrost ', 0x31, '10.00', 946, 8, 3, NULL, NULL, NULL, 5, NULL),
(437, 'Honed Draugr War Axe', 0x31, '16.00', 27, 8, 3, 3, 2, NULL, 11, NULL),
(438, 'Honed Falmer War Axe', 0x31, '21.00', 245, 8, 3, NULL, NULL, NULL, 13, NULL),
(439, 'Illusory War Axe', 0x31, '14.00', 15, 8, 3, NULL, NULL, NULL, 1, NULL),
(440, 'Iron War Axe', 0x31, '11.00', 30, 8, 3, NULL, 1, NULL, 8, NULL),
(441, 'Lunar Iron War Axe (Lvl 2-3)', 0x31, '11.00', 94, 8, 3, NULL, 1, NULL, 8, NULL),
(442, 'Lunar Iron War Axe (Lvl 4-5)', 0x31, '11.00', 128, 8, 3, NULL, 1, NULL, 8, NULL),
(443, 'Lunar Iron War Axe (Lvl 6+)', 0x31, '11.00', 163, 8, 3, NULL, 1, NULL, 8, NULL),
(444, 'Lunar Steel War Axe (Lvl 2-3)', 0x31, '12.00', 119, 8, 3, 1, 2, NULL, 9, NULL),
(445, 'Lunar Steel War Axe (Lvl 4-5)', 0x31, '12.00', 153, 8, 3, 1, 2, NULL, 9, NULL),
(446, 'Lunar Steel War Axe (Lvl 6+)', 0x31, '12.00', 188, 8, 3, 1, 2, NULL, 9, NULL),
(447, 'Nord Hero War Axe', 0x31, '11.00', 165, 8, 3, 1, 2, NULL, 12, NULL),
(448, 'Nordic War Axe ', 0x31, '14.00', 350, 8, 3, 5, 7, NULL, 12, NULL),
(449, 'Notched Pickaxe', 0x31, '10.00', 303, 8, 3, NULL, 1, NULL, 5, NULL),
(450, 'Okin', 0x31, '11.00', 320, 8, 3, 1, 2, NULL, 12, NULL),
(451, 'Orcish War Axe', 0x31, '13.00', 90, 8, 3, 4, 4, NULL, 10, NULL),
(452, 'Pickaxe', 0x31, '10.00', 5, 8, 3, NULL, NULL, NULL, 5, NULL),
(453, 'Poacher\'s Axe', 0x31, '10.00', 32, 8, 3, NULL, 2, NULL, 5, NULL),
(454, 'Skyforge Steel War Axe', 0x31, '12.00', 80, 8, 3, 1, 2, NULL, 12, NULL),
(455, 'Stalhrim War Axe ', 0x31, '16.00', 1180, 8, 3, 7, 14, NULL, 15, NULL),
(456, 'Steel War Axe', 0x31, '12.00', 55, 8, 3, 1, 2, NULL, 9, NULL),
(457, 'Ulfric\'s War Axe', 0x31, '12.00', 55, 8, 3, 1, 2, NULL, 9, NULL),
(458, 'Woodcutter\'s Axe', 0x31, '10.00', 5, 8, 3, NULL, NULL, NULL, 5, NULL),
(459, 'Fork', 0x31, '0.50', 5, 15, 3, NULL, NULL, NULL, 1, NULL),
(460, 'Knife', 0x31, '0.50', 1, 15, 3, NULL, NULL, NULL, 2, NULL),
(461, 'Ancient Nord Greatsword', 0x31, '18.00', 35, 11, 4, 1, 2, NULL, 17, NULL),
(462, 'Balgruuf\'s Greatsword', 0x31, '17.00', 200, 11, 4, 1, 2, NULL, 17, NULL),
(463, 'Bloodskal Blade DR', 0x31, '16.00', 1250, 11, 4, NULL, 22, NULL, 21, NULL),
(464, 'Daedric Greatsword', 0x31, '23.00', 2500, 11, 4, 8, 5, NULL, 24, NULL),
(465, 'Dragonbone Greatsword ', 0x31, '27.00', 2725, 11, 4, 9, 10, NULL, 25, NULL),
(466, 'Dwarven Greatsword', 0x31, '19.00', 270, 11, 4, 3, 6, NULL, 19, NULL),
(467, 'Ebony Greatsword', 0x31, '22.00', 1440, 11, 4, 7, 5, NULL, 22, NULL),
(468, 'Ebony Blade', 0x31, '10.00', 2000, 11, 4, NULL, NULL, NULL, 11, NULL),
(469, 'Elven Greatsword', 0x31, '20.00', 470, 11, 4, 2, 8, NULL, 20, NULL),
(470, 'Glass Greatsword', 0x31, '22.00', 820, 11, 4, 6, 9, NULL, 21, NULL),
(471, 'Honed Ancient Nord Greatsword', 0x31, '21.00', 63, 11, 4, 3, 2, NULL, 20, NULL),
(472, 'Iron Greatsword', 0x31, '16.00', 50, 11, 4, NULL, 1, NULL, 15, NULL),
(473, 'Nord Hero Greatsword', 0x31, '16.00', 250, 11, 4, 1, 2, NULL, 20, NULL),
(474, 'Nordic Greatsword DR', 0x31, '19.00', 585, 11, 4, 5, 7, NULL, 20, NULL),
(475, 'Orcish Greatsword', 0x31, '18.00', 75, 11, 4, 4, 4, NULL, 18, NULL),
(476, 'Silver Greatsword', 0x31, '12.00', 160, 11, 4, NULL, NULL, NULL, 17, NULL),
(477, 'Skyforge Steel Greatsword', 0x31, '17.00', 140, 11, 4, 1, 2, NULL, 20, NULL),
(478, 'Stalhrim Greatsword ', 0x31, '21.00', 1970, 11, 4, 7, 14, NULL, 23, NULL),
(479, 'Steel Greatsword', 0x31, '17.00', 90, 11, 4, 1, 2, NULL, 17, NULL),
(480, 'Stormfang ', 0x31, '17.00', 1175, 11, 4, 1, 2, NULL, 17, NULL),
(481, 'Aegisbane', 0x31, '24.00', 180, 12, 4, NULL, 1, NULL, 18, NULL),
(482, 'Champion\'s Cudgel ', 0x31, '27.00', 1767, 12, 4, NULL, NULL, NULL, 24, NULL),
(483, 'Daedric Warhammer', 0x31, '31.00', 4000, 12, 4, 8, 5, NULL, 27, NULL),
(484, 'Dawnguard Warhammer ', 0x31, '26.00', 110, 12, 4, 1, 2, NULL, 22, NULL),
(485, 'Dawnguard Rune Hammer ', 0x31, '26.00', 500, 12, 4, 1, 2, NULL, 22, NULL),
(486, 'Dragonbone Warhammer ', 0x31, '33.00', 4275, 12, 4, 9, 10, NULL, 28, NULL),
(487, 'Dwarven Warhammer', 0x31, '27.00', 325, 12, 4, 3, 6, NULL, 22, NULL),
(488, 'Ebony Warhammer', 0x31, '30.00', 1725, 12, 4, 7, 5, NULL, 25, NULL),
(489, 'Elven Warhammer', 0x31, '28.00', 565, 12, 4, 2, 8, NULL, 23, NULL),
(490, 'Glass Warhammer', 0x31, '29.00', 985, 12, 4, 6, 9, NULL, 24, NULL),
(491, 'Iron Warhammer', 0x31, '24.00', 60, 12, 4, NULL, 1, NULL, 18, NULL),
(492, 'Nordic Warhammer ', 0x31, '27.00', 700, 12, 4, 5, 7, NULL, 23, NULL),
(493, 'Orcish Warhammer', 0x31, '26.00', 180, 12, 4, 4, 4, NULL, 21, NULL),
(494, 'Shagrol\'s Warhammer', 0x31, '26.00', 200, 12, 4, 4, 4, NULL, 21, NULL),
(495, 'Stalhrim Warhammer ', 0x31, '29.00', 2850, 12, 4, 7, 14, NULL, 26, NULL),
(496, 'Steel Warhammer', 0x31, '25.00', 110, 12, 4, 1, 2, NULL, 20, NULL),
(497, 'The Longhammer', 0x31, '18.00', 90, 12, 4, 4, 4, NULL, 21, NULL),
(498, 'Trollsbane', 0x31, '25.00', 121, 12, 4, 1, 2, NULL, 20, NULL),
(499, 'Volendrung', 0x31, '26.00', 1843, 12, 4, NULL, 5, NULL, 25, NULL),
(500, 'Ancient Nord Bow', 0x31, '12.00', 45, 13, 5, 1, 2, NULL, 8, 1),
(501, 'Angi\'s Bow', 0x31, '7.00', 50, 13, 5, 1, 2, NULL, 7, 1),
(502, 'Auriel\'s Bow DG', 0x31, '11.00', 1000, 13, 5, 2, 8, NULL, 13, 1),
(503, 'Bow of the Hunt', 0x31, '7.00', 434, 13, 5, 1, 2, NULL, 10, 1),
(504, 'Daedric Bow', 0x31, '18.00', 2500, 13, 5, 8, 5, NULL, 19, 1),
(505, 'Dragonbone Bow DG', 0x31, '20.00', 2725, 13, 5, 9, 10, NULL, 20, 1),
(506, 'Drainspell Bow', 0x31, '6.00', 458, 13, 5, NULL, NULL, NULL, 14, 1),
(507, 'Dravin\'s Bow', 0x31, '7.00', 50, 13, 5, 1, 20, NULL, 7, 1),
(508, 'Dwarven Bow', 0x31, '10.00', 270, 13, 5, 3, 6, NULL, 12, 1),
(509, 'Dwarven Black Bow of Fate DR', 0x31, '10.00', 1446, 13, 5, 3, 5, NULL, 13, 1),
(510, 'Ebony Bow', 0x31, '16.00', 1440, 13, 5, 7, 5, NULL, 17, 1),
(511, 'Elven Bow', 0x31, '12.00', 470, 13, 5, 2, 8, NULL, 13, 1),
(512, 'Falmer Bow', 0x31, '15.00', 135, 13, 5, NULL, 13, NULL, 12, 1),
(513, 'Falmer Supple Bow', 0x31, '20.00', 410, 13, 5, NULL, NULL, NULL, 15, 1),
(514, 'Firiniel\'s End', 0x31, '12.00', 785, 13, 5, 2, 8, NULL, 13, 1),
(515, 'Forsworn Bow', 0x31, '11.00', 145, 13, 5, 1, 2, NULL, 12, 1),
(516, 'Froki\'s Bow', 0x31, '5.00', 307, 13, 5, NULL, 1, NULL, 6, 1),
(517, 'Gauldur Blackbow', 0x31, '12.00', 253, 13, 5, 3, 2, NULL, 8, 1),
(518, 'Gauldur Blackbow', 0x31, '12.00', 407, 13, 5, 3, 2, NULL, 8, 1),
(519, 'Gauldur Blackbow', 0x31, '18.00', 530, 13, 5, 3, 2, NULL, 14, 1),
(520, 'Gauldur Blackbow', 0x31, '18.00', 750, 13, 5, 3, 2, NULL, 14, 1),
(521, 'Gauldur Blackbow', 0x31, '18.00', 972, 13, 5, 3, 2, NULL, 14, 1),
(522, 'Glass Bow', 0x31, '14.00', 820, 13, 5, 6, 9, NULL, 15, 1),
(523, 'Glass Bow of the Stag Prince DR', 0x31, '14.00', 375, 13, 5, 6, 9, NULL, 16, 1),
(524, 'Hunting Bow', 0x31, '7.00', 50, 13, 5, 1, 20, NULL, 7, 1),
(525, 'Imperial Bow', 0x31, '8.00', 90, 13, 5, NULL, 2, NULL, 9, 1),
(526, 'Karliah\'s Bow', 0x31, '9.00', 5, 13, 5, NULL, NULL, NULL, 25, 1),
(527, 'Long Bow', 0x31, '5.00', 30, 13, 5, NULL, 11, NULL, 6, 1),
(528, 'Nord Hero Bow', 0x31, '7.00', 200, 13, 5, NULL, 2, NULL, 11, 1),
(529, 'Nordic Bow DR', 0x31, '11.00', 580, 13, 5, 5, 7, NULL, 13, 1),
(530, 'Orcish Bow', 0x31, '9.00', 150, 13, 5, 4, 4, NULL, 10, 1),
(531, 'Stalhrim Bow DR', 0x31, '15.00', 1800, 13, 5, 7, 14, NULL, 17, 1),
(532, 'Supple Ancient Nord Bow', 0x31, '18.00', 235, 13, 5, NULL, NULL, NULL, 14, 1),
(533, 'Nightingale Bow', 0x31, '9.00', 493, 13, 5, NULL, 5, NULL, 12, 1),
(534, 'Nightingale Bow', 0x31, '11.00', 838, 13, 5, NULL, 5, NULL, 13, 1),
(535, 'Nightingale Bow', 0x31, '13.00', 1409, 13, 5, NULL, 5, NULL, 15, 1),
(536, 'Nightingale Bow', 0x31, '15.00', 2240, 13, 5, NULL, 5, NULL, 17, 1),
(537, 'Nightingale Bow', 0x31, '18.00', 3405, 13, 5, NULL, 5, NULL, 19, 1),
(538, 'Zephyr DG', 0x31, '10.00', 670, 13, 5, 3, 6, NULL, 12, 1),
(539, 'Ancient Nord Arrow', 0x31, '0.00', 1, 16, 5, NULL, NULL, NULL, 10, NULL),
(540, 'Bloodcursed Elven Arrow DG', 0x31, '0.00', 6, 16, 5, NULL, NULL, NULL, 16, NULL),
(541, 'Daedric Arrow', 0x31, '0.00', 8, 16, 5, NULL, NULL, NULL, 24, NULL),
(542, 'Dragonbone Arrow DG', 0x31, '0.00', 9, 16, 5, NULL, NULL, NULL, 25, NULL),
(543, 'Dwarven Arrow', 0x31, '0.00', 4, 16, 5, NULL, NULL, NULL, 14, NULL),
(544, 'Dwarven Sphere Centurion Arrow', 0x31, '0.00', 0, 16, 5, NULL, NULL, NULL, 20, NULL),
(545, 'Ebony Arrow', 0x31, '0.00', 7, 16, 5, NULL, NULL, NULL, 20, NULL),
(546, 'Elven Arrow', 0x31, '0.00', 5, 16, 5, NULL, NULL, NULL, 16, NULL),
(547, 'Falmer Arrow', 0x31, '0.00', 1, 16, 5, NULL, NULL, NULL, 7, NULL),
(548, 'Forsworn Arrow', 0x31, '0.00', 1, 16, 5, NULL, NULL, NULL, 7, NULL),
(549, 'Glass Arrow', 0x31, '0.00', 6, 16, 5, NULL, NULL, NULL, 18, NULL),
(550, 'Iron Arrow', 0x31, '0.00', 1, 16, 5, NULL, NULL, NULL, 8, NULL),
(551, 'Nordic Arrow DR', 0x31, '0.00', 4, 16, 5, NULL, NULL, NULL, 14, NULL),
(552, 'Orcish Arrow', 0x31, '0.00', 3, 16, 5, NULL, NULL, NULL, 12, NULL),
(553, 'Practice Arrow', 0x31, '0.00', 0, 16, 5, NULL, NULL, NULL, 0, NULL),
(554, 'Riekling Spear DR', 0x31, '0.00', 2, 16, 5, NULL, NULL, NULL, 10, NULL),
(555, 'Rusty Arrow', 0x31, '0.00', 0, 16, 5, NULL, NULL, NULL, 4, NULL),
(556, 'Stalhrim Arrow DR', 0x31, '0.00', 7, 16, 5, NULL, NULL, NULL, 20, NULL),
(557, 'Steel Arrow', 0x31, '0.00', 2, 16, 5, NULL, NULL, NULL, 10, NULL),
(558, 'Sunhallowed Elven Arrow DG', 0x31, '0.00', 16, 16, 5, NULL, NULL, NULL, 16, NULL),
(559, 'Crossbow', 0x31, '14.00', 120, 14, 5, NULL, 2, NULL, 19, NULL),
(560, 'Dwarven Crossbow', 0x31, '20.00', 350, 14, 5, NULL, 6, NULL, 22, NULL),
(561, 'Enhanced Crossbow', 0x31, '15.00', 200, 14, 5, NULL, 2, NULL, 19, NULL),
(562, 'Enhanced Dwarven Crossbow', 0x31, '21.00', 550, 14, 5, NULL, 6, NULL, 22, NULL),
(563, 'Steel Bolt', 0x31, '0.00', 1, 17, 5, NULL, NULL, NULL, 10, NULL),
(564, 'Dwarven Bolt', 0x31, '0.00', 3, 17, 5, NULL, NULL, NULL, 14, NULL),
(565, 'Exploding Steel Bolt of Fire', 0x31, '0.00', 5, 17, 5, NULL, NULL, NULL, 10, NULL),
(566, 'Exploding Steel Bolt of Ice', 0x31, '0.00', 5, 17, 5, NULL, NULL, NULL, 10, NULL),
(567, 'Exploding Steel Bolt of Shock', 0x31, '0.00', 5, 17, 5, NULL, NULL, NULL, 10, NULL),
(568, 'Exploding Dwarven Bolt of Fire', 0x31, '0.00', 15, 17, 5, NULL, NULL, NULL, 14, NULL),
(569, 'Exploding Dwarven Bolt of Ice', 0x31, '0.00', 15, 17, 5, NULL, NULL, NULL, 14, NULL),
(570, 'Exploding Dwarven Bolt of Shock', 0x31, '0.00', 15, 17, 5, NULL, NULL, NULL, 14, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `perk`
--

CREATE TABLE `perk` (
  `perk_id` int(11) NOT NULL,
  `perk_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `perk`
--

INSERT INTO `perk` (`perk_id`, `perk_name`) VALUES
(5, 'Advanced'),
(8, 'Daedric'),
(9, 'Dragon'),
(3, 'Dwarven'),
(7, 'Ebony'),
(2, 'Elven'),
(11, 'Firewood'),
(6, 'Glass'),
(4, 'Orcish'),
(1, 'Steel'),
(10, 'Steel or Advanced');

-- --------------------------------------------------------

--
-- Table structure for table `race`
--

CREATE TABLE `race` (
  `race_id` int(11) NOT NULL,
  `race_name` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `race`
--

INSERT INTO `race` (`race_id`, `race_name`) VALUES
(1, 'Altmer'),
(2, 'Argonian'),
(3, 'Bosmer'),
(4, 'Breton'),
(5, 'Dunmer'),
(6, 'Imperial'),
(7, 'Khajiit'),
(8, 'Nord'),
(9, 'Orsimer'),
(10, 'Redguard');

-- --------------------------------------------------------

--
-- Table structure for table `skill`
--

CREATE TABLE `skill` (
  `skill_id` int(11) NOT NULL,
  `skill_name` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `skill`
--

INSERT INTO `skill` (`skill_id`, `skill_name`) VALUES
(8, 'Alchemy'),
(15, 'Alteration'),
(3, 'Archery'),
(4, 'Block'),
(16, 'Conjuration'),
(13, 'Destruction'),
(18, 'Enchanting'),
(5, 'Heavy Armor'),
(17, 'Illusion'),
(6, 'Light Armor'),
(10, 'Lockpicking'),
(1, 'One-Handed'),
(11, 'Pickpocket'),
(14, 'Restoration'),
(7, 'Smithing'),
(9, 'Sneak'),
(12, 'Speech'),
(2, 'Two-Handed');

-- --------------------------------------------------------

--
-- Table structure for table `upgrade_material`
--

CREATE TABLE `upgrade_material` (
  `material_id` int(11) NOT NULL,
  `material_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `upgrade_material`
--

INSERT INTO `upgrade_material` (`material_id`, `material_name`) VALUES
(17, 'Bone Meal'),
(13, 'Chaurus Chitin'),
(12, 'Chitin Plate'),
(3, 'Corundum Ingot'),
(21, 'Corundum Ingot and Ectoplasm'),
(19, 'Daedra Heart and Ebony Ingot'),
(10, 'Dragon Bone'),
(11, 'Dragon Scales'),
(6, 'Dwarven Metal Ingot'),
(5, 'Ebony Ingot'),
(18, 'Gold Ingot'),
(1, 'Iron Ingot'),
(15, 'Leather'),
(20, 'Leather Strips'),
(4, 'Orichalcum Ingot'),
(7, 'Quicksilver Ingot'),
(9, 'Refined Malachite'),
(8, 'Refined Moonstone'),
(22, 'Silver Ingot'),
(14, 'Stalhrim'),
(2, 'Steel Ingot'),
(16, 'Void Salts');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`account_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `category_name` (`category_name`);

--
-- Indexes for table `character`
--
ALTER TABLE `character`
  ADD PRIMARY KEY (`character_id`),
  ADD UNIQUE KEY `unique_account_character` (`account_id`,`character_id`),
  ADD KEY `idx_character_player` (`account_id`),
  ADD KEY `idx_character_race` (`race_id`);

--
-- Indexes for table `character_skill`
--
ALTER TABLE `character_skill`
  ADD PRIMARY KEY (`character_id`,`skill_id`),
  ADD KEY `skill_id` (`skill_id`);

--
-- Indexes for table `classification`
--
ALTER TABLE `classification`
  ADD PRIMARY KEY (`classification_id`),
  ADD UNIQUE KEY `classification_name` (`classification_name`);

--
-- Indexes for table `inventory_item`
--
ALTER TABLE `inventory_item`
  ADD PRIMARY KEY (`inventory_item_id`),
  ADD UNIQUE KEY `character_id` (`character_id`,`item_id`),
  ADD UNIQUE KEY `character_id_2` (`character_id`,`item_id`),
  ADD KEY `fk_inventory_item_item` (`item_id`);

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `idx_item_type` (`item_type`),
  ADD KEY `fk_item_category` (`category_id`),
  ADD KEY `fk_item_classification` (`classification_id`),
  ADD KEY `fk_item_perk` (`perk_id`),
  ADD KEY `fk_item_upgrade` (`item_upgrade`);

--
-- Indexes for table `perk`
--
ALTER TABLE `perk`
  ADD PRIMARY KEY (`perk_id`),
  ADD UNIQUE KEY `perk_name` (`perk_name`);

--
-- Indexes for table `race`
--
ALTER TABLE `race`
  ADD PRIMARY KEY (`race_id`),
  ADD UNIQUE KEY `race_name` (`race_name`);

--
-- Indexes for table `skill`
--
ALTER TABLE `skill`
  ADD PRIMARY KEY (`skill_id`),
  ADD UNIQUE KEY `skill_name` (`skill_name`);

--
-- Indexes for table `upgrade_material`
--
ALTER TABLE `upgrade_material`
  ADD PRIMARY KEY (`material_id`),
  ADD UNIQUE KEY `material_name` (`material_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `character`
--
ALTER TABLE `character`
  MODIFY `character_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `classification`
--
ALTER TABLE `classification`
  MODIFY `classification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inventory_item`
--
ALTER TABLE `inventory_item`
  MODIFY `inventory_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'item_id', AUTO_INCREMENT=571;

--
-- AUTO_INCREMENT for table `perk`
--
ALTER TABLE `perk`
  MODIFY `perk_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `race`
--
ALTER TABLE `race`
  MODIFY `race_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `skill`
--
ALTER TABLE `skill`
  MODIFY `skill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `upgrade_material`
--
ALTER TABLE `upgrade_material`
  MODIFY `material_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `character`
--
ALTER TABLE `character`
  ADD CONSTRAINT `character_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `character_ibfk_2` FOREIGN KEY (`race_id`) REFERENCES `race` (`race_id`);

--
-- Constraints for table `character_skill`
--
ALTER TABLE `character_skill`
  ADD CONSTRAINT `character_skill_ibfk_1` FOREIGN KEY (`character_id`) REFERENCES `character` (`character_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `character_skill_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skill` (`skill_id`);

--
-- Constraints for table `inventory_item`
--
ALTER TABLE `inventory_item`
  ADD CONSTRAINT `fk_inventory_item_item` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`);

--
-- Constraints for table `item`
--
ALTER TABLE `item`
  ADD CONSTRAINT `fk_item_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`),
  ADD CONSTRAINT `fk_item_classification` FOREIGN KEY (`classification_id`) REFERENCES `classification` (`classification_id`),
  ADD CONSTRAINT `fk_item_perk` FOREIGN KEY (`perk_id`) REFERENCES `perk` (`perk_id`),
  ADD CONSTRAINT `fk_item_upgrade` FOREIGN KEY (`item_upgrade`) REFERENCES `upgrade_material` (`material_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
