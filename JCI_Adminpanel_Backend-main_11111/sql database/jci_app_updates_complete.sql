-- =============================================================================
-- JCI APP - COMPLETE SQL UPDATE (Run once in MySQL Workbench)
-- =============================================================================
-- What this file does:
--   1. Adds connect_amount column to Referral table (for Non Closed Connect amount)
--   2. Creates FitnessStory table (Fitness Club WhatsApp-style stories, 24h expiry)
--
-- How to run in MySQL Workbench:
--   1. Open this file: File -> Open SQL Script
--   2. Click Execute (lightning bolt icon) or press Ctrl+Shift+Enter
--   3. Restart your Node.js backend after success
-- =============================================================================

USE jci;

-- -----------------------------------------------------------------------------
-- PART 1: Referral - add connect_amount column (safe if run twice)
-- -----------------------------------------------------------------------------
SET @dbname = DATABASE();
SET @tablename = 'Referral';
SET @columnname = 'connect_amount';

SET @sql = (
  SELECT IF(
    (
      SELECT COUNT(*)
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = @dbname
        AND TABLE_NAME = @tablename
        AND COLUMN_NAME = @columnname
    ) > 0,
    'SELECT ''OK: connect_amount column already exists on Referral'' AS result;',
    'ALTER TABLE `Referral` ADD COLUMN `connect_amount` DECIMAL(12,2) DEFAULT NULL AFTER `connection_type`;'
  )
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- -----------------------------------------------------------------------------
-- PART 2: Fitness Club - create FitnessStory table (24-hour stories)
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- PART 3: Verify - show updated structure
-- -----------------------------------------------------------------------------
SELECT 'Referral table columns:' AS info;
SHOW COLUMNS FROM `Referral`;

SELECT 'FitnessStory table columns:' AS info;
SHOW COLUMNS FROM `FitnessStory`;

SELECT 'SUCCESS: All updates applied. Restart backend server now.' AS status;
