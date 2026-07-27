-- =============================================================================
-- JCI ERODE GREENCITY — PRODUCTION LIVE SERVER (END-TO-END)
-- =============================================================================
-- File: jci_production_live_setup.sql
-- Run ONCE on fresh MySQL 8.x as root / hosting admin.
--
--   Database : api_jcierodegreencity
--   DB user  : jcierodegreencity
--   API      : https://api.jcierodegreencity.com
--   Admin    : https://adminpanel.jcierodegreencity.com
--   Node port: 4026
--
-- HOW TO RUN:
--   phpMyAdmin → Import → this file
--   mysql -u root -p < jci_production_live_setup.sql
--
-- Backend .env must match:
--   HS_DB_NAME=api_jcierodegreencity
--   HS_DB_USERNAME=jcierodegreencity
--   HS_DB_PASSWORD=LcCeoa6qP9ePMqu
--   HS_PORT=4026
--   HS_IMAGE=https://api.jcierodegreencity.com
--
-- Admin login: admin@jci.local / Admin@12345 (change after first login)
-- WARNING: Drops database api_jcierodegreencity if it exists.
-- =============================================================================

-- =============================================================================
-- PART 1: SCHEMA + MINIMAL SEED (admin, roles, business types only)
-- =============================================================================
-- JCI COMPLETE DATABASE (Mobile + Admin + Referral + Fitness)
-- HOW TO RUN: Press Ctrl+A to select ALL, then click Execute (lightning bolt)

DROP DATABASE IF EXISTS `api_jcierodegreencity`;
CREATE DATABASE `api_jcierodegreencity` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `api_jcierodegreencity`;

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';

CREATE TABLE `Admin` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email_id` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `user_type` enum('ROOT','USER') NOT NULL DEFAULT 'USER',
  `status` enum('active','inactive','terminated') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Production admin (change password after first login)
-- Login: admin@jci.local / Admin@12345
--

INSERT INTO `Admin` (`id`, `email_id`, `phone`, `username`, `password`, `user_type`, `status`, `createdAt`, `updatedAt`) VALUES
(1, 'admin@jci.local', '+910000000000', 'admin', '$2b$10$rAfJx7OAI087t96Lj7pVVuT3eSkBgqbV7iVGczHMB4YHXlND/4kaC', 'ROOT', 'active', NOW(), NOW());

-- --------------------------------------------------------

--
-- Table structure for table `Banners`
--

CREATE TABLE `Banners` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `banner_image` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `BloodReq`
--

CREATE TABLE `BloodReq` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `NameOfPatient` varchar(255) NOT NULL,
  `BloodGroup` varchar(255) NOT NULL,
  `NoOfUnits` varchar(255) NOT NULL,
  `Hospital_name` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `Contact` varchar(255) NOT NULL,
  `Attender` varchar(255) NOT NULL,
  `VerifiedBy` varchar(255) DEFAULT '',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `boardMembers`
--

CREATE TABLE `boardMembers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `BusinessType`
--

CREATE TABLE `BusinessType` (
  `id` int(11) NOT NULL,
  `Business_category` varchar(255) NOT NULL,
  `department` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `BusinessType`
--

INSERT INTO `BusinessType` (`id`, `Business_category`, `department`, `createdAt`, `updatedAt`) VALUES
(1, 'banking', 'manager', '2024-03-13 10:03:32', '2024-03-13 10:03:32'),
(2, 'college', 'student', '2024-03-13 10:03:51', '2024-03-13 10:03:51'),
(3, 'college', 'lecturer', '2024-03-13 10:04:04', '2024-03-13 10:04:04'),
(4, 'banking ', 'clerk', '2024-03-13 10:04:32', '2024-03-13 10:04:32'),
(5, 'banking', 'sales staff', '2024-03-13 10:04:43', '2024-03-13 10:04:43');

-- --------------------------------------------------------

--
-- Table structure for table `Designation`
--

CREATE TABLE `Designation` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `designation_name` varchar(255) NOT NULL,
  `designation_year` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Events`
--

CREATE TABLE `Events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `event_name` varchar(255) NOT NULL,
  `event_image` varchar(255) NOT NULL,
  `event_date` varchar(255) NOT NULL,
  `event_time` varchar(255) NOT NULL,
  `event_location` varchar(255) NOT NULL,
  `event_desc` text NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `eventsImage`
--

CREATE TABLE `eventsImage` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `event_id` bigint(20) UNSIGNED NOT NULL,
  `event_name` varchar(255) NOT NULL,
  `event_image` varchar(255) NOT NULL,
  `status` enum('active','inactive','terminated') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Family`
--

CREATE TABLE `Family` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `dob` varchar(255) NOT NULL,
  `anniversary` varchar(20) DEFAULT NULL,
  `blood_group` enum('O+','O-','A+','A-','B+','B-','AB+','AB-','A1+','A2+','A1B+','A1B-','A2B+','HH') NOT NULL,
  `relationship` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `folderName`
--

CREATE TABLE `folderName` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `folderName` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `GreenChannel`
--

CREATE TABLE `GreenChannel` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pdf_url` text NOT NULL,
  `pdf_name` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Member`
--

CREATE TABLE `Member` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `membership_id` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `gender` enum('male','female','others') DEFAULT 'male',
  `dob` varchar(15) DEFAULT NULL,
  `location` text DEFAULT NULL,
  `blood_group` enum('O+','O-','A+','A-','B+','B-','AB+','AB-','A1+','A2+','A1B+','A1B-','A2B+','HH') DEFAULT NULL,
  `willing_to_donate` enum('yes','no') DEFAULT NULL,
  `office_name` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `sector` varchar(255) DEFAULT NULL,
  `martial_status` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `jci_location` varchar(255) DEFAULT NULL,
  `type` enum('member','boardmember') DEFAULT 'member',
  `status` enum('active','inactive') DEFAULT 'active',
  `app_access` enum('view','full') NOT NULL DEFAULT 'view',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `notification_type` enum('member','boardmember') NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `roleOfHonour`
--

CREATE TABLE `roleOfHonour` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `role_of_honour_year` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Sponser`
--

CREATE TABLE `Sponser` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sponser_name` varchar(255) NOT NULL,
  `sponser_image` varchar(255) DEFAULT NULL,
  `sponser_contact` varchar(255) NOT NULL,
  `sponser_email` varchar(255) NOT NULL,
  `sponser_description` varchar(255) NOT NULL,
  `sponser_location` varchar(255) NOT NULL,
  `sponser_website` varchar(255) NOT NULL,
  `sponser_expiryTime` varchar(255) NOT NULL,
  `role` enum('sponser','main_sponser') DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `userRoles`
--

CREATE TABLE `userRoles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_name` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userRoles`
--

INSERT INTO `userRoles` (`id`, `role_name`, `createdAt`, `updatedAt`) VALUES
(1, 'Director', '2021-12-15 15:05:39', '2021-12-15 15:05:39'),
(2, 'President', '2021-12-15 15:05:56', '2021-12-15 15:05:56'),
(3, 'Vice President - Resource, Business and Internationalisim ', '2021-12-15 15:32:37', '2021-12-15 15:32:37'),
(4, 'Secretary', '2021-12-15 15:32:58', '2021-12-15 15:32:58'),
(5, 'Member', '2021-12-15 15:33:15', '2021-12-15 15:33:15'),
(7, 'Vice President - Management', '2021-12-15 15:34:05', '2021-12-15 15:34:05'),
(8, 'Vice President - Community', '2021-12-15 15:34:23', '2021-12-15 15:34:23'),
(9, 'Vice President - Individual Development', '2021-12-15 15:34:47', '2021-12-15 15:34:47'),
(10, 'Treasurer', '2021-12-15 15:35:03', '2021-12-15 15:35:03'),
(11, 'Joint Secretary', '2021-12-15 15:35:23', '2021-12-15 15:35:23'),
(12, 'Immediate Past President', '2021-12-16 15:13:02', '2021-12-16 15:13:02'),
(13, 'Past President', '2022-01-27 13:20:46', '2022-01-27 13:20:46'),
(15, 'Demo', '2022-03-23 05:37:18', '2022-03-23 05:37:18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Admin`
--
ALTER TABLE `Admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Banners`
--
ALTER TABLE `Banners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `BloodReq`
--
ALTER TABLE `BloodReq`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `boardMembers`
--
ALTER TABLE `boardMembers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `BusinessType`
--
ALTER TABLE `BusinessType`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Designation`
--
ALTER TABLE `Designation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `Events`
--
ALTER TABLE `Events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `eventsImage`
--
ALTER TABLE `eventsImage`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Family`
--
ALTER TABLE `Family`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `folderName`
--
ALTER TABLE `folderName`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `GreenChannel`
--
ALTER TABLE `GreenChannel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Member`
--
ALTER TABLE `Member`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roleOfHonour`
--
ALTER TABLE `roleOfHonour`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `Sponser`
--
ALTER TABLE `Sponser`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `userRoles`
--
ALTER TABLE `userRoles`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Admin`
--
ALTER TABLE `Admin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `Banners`
--
ALTER TABLE `Banners`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `BloodReq`
--
ALTER TABLE `BloodReq`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `boardMembers`
--
ALTER TABLE `boardMembers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `BusinessType`
--
ALTER TABLE `BusinessType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Designation`
--
ALTER TABLE `Designation`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `Events`
--
ALTER TABLE `Events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `eventsImage`
--
ALTER TABLE `eventsImage`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `Family`
--
ALTER TABLE `Family`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `folderName`
--
ALTER TABLE `folderName`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `GreenChannel`
--
ALTER TABLE `GreenChannel`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `Member`
--
ALTER TABLE `Member`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `roleOfHonour`
--
ALTER TABLE `roleOfHonour`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Sponser`
--
ALTER TABLE `Sponser`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `userRoles`
--
ALTER TABLE `userRoles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `boardMembers`
--
ALTER TABLE `boardMembers`
  ADD CONSTRAINT `boardMembers_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Designation`
--
ALTER TABLE `Designation`
  ADD CONSTRAINT `Designation_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `roleOfHonour`
--
ALTER TABLE `roleOfHonour`
  ADD CONSTRAINT `roleOfHonour_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`) ON UPDATE CASCADE;

CREATE TABLE `MemberAuth` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint UNSIGNED NOT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `login_email` varchar(255) DEFAULT NULL,
  `login_phone` varchar(50) DEFAULT NULL,
  `is_setup_complete` tinyint(1) NOT NULL DEFAULT 0,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_id` (`member_id`),
  UNIQUE KEY `google_id` (`google_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `PasswordResetToken` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint UNSIGNED NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `type` enum('email_link','identity_verify') NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT 0,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `MemberSession` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint UNSIGNED NOT NULL,
  `fcm_token` varchar(512) DEFAULT NULL,
  `device_info` varchar(255) DEFAULT NULL,
  `last_active` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fcm_token` (`fcm_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Referral` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `referrer_member_id` bigint UNSIGNED NOT NULL,
  `linked_member_id` bigint UNSIGNED DEFAULT NULL,
  `referral_type` enum('self','jci_member','non_jci_member') NOT NULL,
  `referred_name` varchar(255) NOT NULL,
  `referred_phone` varchar(50) NOT NULL,
  `remark` text DEFAULT NULL,
  `referred_member_id` bigint UNSIGNED DEFAULT NULL,
  `status` enum('pending','accepted','rejected') NOT NULL DEFAULT 'pending',
  `connection_type` enum('non_closed_connect','completed') DEFAULT NULL,
  `connect_amount` decimal(12,2) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `FitnessStory` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint UNSIGNED NOT NULL,
  `image_path` varchar(512) NOT NULL,
  `expires_at` datetime NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_fitness_expires` (`expires_at`),
  KEY `idx_fitness_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

SELECT 'SUCCESS: JCI production database installed.' AS Status;
-- =============================================================================
-- PART 2: PRODUCTION MYSQL APP USER (jcierodegreencity)
-- =============================================================================

CREATE USER IF NOT EXISTS 'jcierodegreencity'@'localhost' IDENTIFIED BY 'LcCeoa6qP9ePMqu';
CREATE USER IF NOT EXISTS 'jcierodegreencity'@'127.0.0.1' IDENTIFIED BY 'LcCeoa6qP9ePMqu';
-- If backend runs on a different host than MySQL, also grant from that host:
-- CREATE USER IF NOT EXISTS 'jcierodegreencity'@'10.0.0.5' IDENTIFIED BY 'LcCeoa6qP9ePMqu';

GRANT ALL PRIVILEGES ON api_jcierodegreencity.* TO 'jcierodegreencity'@'localhost';
GRANT ALL PRIVILEGES ON api_jcierodegreencity.* TO 'jcierodegreencity'@'127.0.0.1';
FLUSH PRIVILEGES;

-- =============================================================================
-- PART 3: VERIFY INSTALLATION
-- =============================================================================

SELECT 'Database' AS check_type, DATABASE() AS value;
SELECT 'Tables' AS check_type, COUNT(*) AS value FROM information_schema.tables WHERE table_schema = 'api_jcierodegreencity';
SELECT 'Admin users' AS check_type, COUNT(*) AS value FROM `Admin`;
SELECT 'Members' AS check_type, COUNT(*) AS value FROM `Member`;
SELECT 'Referral module' AS check_type, IF(COUNT(*) > 0, 'OK', 'MISSING') AS value FROM information_schema.tables WHERE table_schema = 'api_jcierodegreencity' AND table_name = 'Referral';
SELECT 'Fitness module' AS check_type, IF(COUNT(*) > 0, 'OK', 'MISSING') AS value FROM information_schema.tables WHERE table_schema = 'api_jcierodegreencity' AND table_name = 'FitnessStory';
SELECT 'Member auth' AS check_type, IF(COUNT(*) > 0, 'OK', 'MISSING') AS value FROM information_schema.tables WHERE table_schema = 'api_jcierodegreencity' AND table_name = 'MemberAuth';

SELECT 'SUCCESS: JCI production live server is ready. Start Node.js on port 4026.' AS Final_Status;

