-- Member app access: view = browse only; full = can give/respond referrals + post stories
ALTER TABLE `Member`
  ADD COLUMN `app_access` ENUM('view', 'full') NOT NULL DEFAULT 'view' AFTER `status`;

-- 1B: everyone starts view-only (including existing rows via DEFAULT)
UPDATE `Member` SET `app_access` = 'view' WHERE `app_access` IS NULL OR `app_access` = '';
