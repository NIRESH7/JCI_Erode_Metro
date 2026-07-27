-- =============================================================================
-- JCI APP — END TO END SQL (Referral + Fitness Club)
-- =============================================================================
-- Run this ENTIRE file once in MySQL Workbench
--   File -> Open SQL Script -> Execute (lightning bolt)
--
-- Matches Node.js / Sequelize models:
--   src/core/database/models/referralAuthModel.js
--     - MemberAuth
--     - PasswordResetToken
--     - MemberSession
--     - Referral  (includes connect_amount for Completed accept flow)
--   src/core/database/models/fitnessStoryModel.js
--     - FitnessStory  (24-hour fitness club stories)
--
-- Safe on EXISTING database:
--   - CREATE TABLE IF NOT EXISTS (skips if table already there)
--   - connect_amount added only if missing
--
-- After run: RESTART Node.js backend, then hot restart Flutter app (R)
-- =============================================================================

USE jci;

SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================================
-- 1. MemberAuth
-- Model: MemberAuth (member login, Google, password)
-- =============================================================================
CREATE TABLE IF NOT EXISTS `MemberAuth` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) UNSIGNED NOT NULL,
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

-- =============================================================================
-- 2. PasswordResetToken
-- Model: PasswordResetToken (forgot password flow)
-- =============================================================================
CREATE TABLE IF NOT EXISTS `PasswordResetToken` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `type` enum('email_link','identity_verify') NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT 0,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_prt_member` (`member_id`),
  KEY `idx_prt_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================================
-- 3. MemberSession
-- Model: MemberSession (FCM push tokens, active members)
-- =============================================================================
CREATE TABLE IF NOT EXISTS `MemberSession` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `fcm_token` varchar(512) DEFAULT NULL,
  `device_info` varchar(255) DEFAULT NULL,
  `last_active` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fcm_token` (`fcm_token`),
  KEY `idx_ms_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================================
-- 4. Referral
-- Model: Referral
--
-- App flow:
--   pending  -> user taps Accept or Reject
--   Accept   -> Completed (enter connect_amount) OR Non Closed Connect (no amount)
--   Reject   -> status = rejected
--   Home page shows SUM(connect_amount) where connection_type = 'completed'
-- =============================================================================
CREATE TABLE IF NOT EXISTS `Referral` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `referrer_member_id` bigint(20) UNSIGNED NOT NULL,
  `linked_member_id` bigint(20) UNSIGNED DEFAULT NULL,
  `referral_type` enum('self','jci_member','non_jci_member') NOT NULL,
  `referred_name` varchar(255) NOT NULL,
  `referred_phone` varchar(50) NOT NULL,
  `referred_member_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('pending','accepted','rejected') NOT NULL DEFAULT 'pending',
  `connection_type` enum('non_closed_connect','completed') DEFAULT NULL,
  `connect_amount` decimal(12,2) DEFAULT NULL COMMENT 'Amount when accepted as completed',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ref_referrer` (`referrer_member_id`),
  KEY `idx_ref_linked` (`linked_member_id`),
  KEY `idx_ref_status` (`status`),
  KEY `idx_ref_connection` (`connection_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- If Referral table already existed WITHOUT connect_amount, add it now
SET @dbname = DATABASE();
SET @sql_add_amount = (
  SELECT IF(
    (
      SELECT COUNT(*)
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = @dbname
        AND TABLE_NAME = 'Referral'
        AND COLUMN_NAME = 'connect_amount'
    ) > 0,
    'SELECT ''OK: Referral.connect_amount already exists'' AS migration_step;',
    'ALTER TABLE `Referral` ADD COLUMN `connect_amount` DECIMAL(12,2) DEFAULT NULL COMMENT ''Amount when accepted as completed'' AFTER `connection_type`;'
  )
);
PREPARE stmt_amount FROM @sql_add_amount;
EXECUTE stmt_amount;
DEALLOCATE PREPARE stmt_amount;

-- =============================================================================
-- 5. FitnessStory
-- Model: FitnessStory
--
-- App flow:
--   Member uploads photo -> image_path saved, expires_at = now + 24 hours
--   All members see active stories (expires_at > NOW())
--   Cron job deletes expired rows every hour
-- =============================================================================
CREATE TABLE IF NOT EXISTS `FitnessStory` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `image_path` varchar(512) NOT NULL,
  `expires_at` datetime NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_fitness_expires` (`expires_at`),
  KEY `idx_fitness_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- VERIFICATION (check output below)
-- =============================================================================
SELECT '=== MemberAuth ===' AS `Table_Check`;
SHOW COLUMNS FROM `MemberAuth`;

SELECT '=== PasswordResetToken ===' AS `Table_Check`;
SHOW COLUMNS FROM `PasswordResetToken`;

SELECT '=== MemberSession ===' AS `Table_Check`;
SHOW COLUMNS FROM `MemberSession`;

SELECT '=== Referral (must have connect_amount) ===' AS `Table_Check`;
SHOW COLUMNS FROM `Referral`;

SELECT '=== FitnessStory ===' AS `Table_Check`;
SHOW COLUMNS FROM `FitnessStory`;

SELECT 'SUCCESS: End-to-end SQL applied. Restart backend + Flutter app now.' AS `Final_Status`;
