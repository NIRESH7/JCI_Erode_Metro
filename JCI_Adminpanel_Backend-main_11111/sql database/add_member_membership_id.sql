-- Optional JCI membership ID on Member (profile / bulk import)
ALTER TABLE `Member`
  ADD COLUMN `membership_id` VARCHAR(255) NULL AFTER `user_name`;
