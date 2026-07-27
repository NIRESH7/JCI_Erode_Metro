-- Add connect amount for non-closed referral connections
USE jci;

ALTER TABLE `Referral`
  ADD COLUMN `connect_amount` DECIMAL(12,2) DEFAULT NULL AFTER `connection_type`;
