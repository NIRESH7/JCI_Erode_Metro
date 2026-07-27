-- Optional JCI chapter/location on Member (complete-profile form)
ALTER TABLE `Member`
  ADD COLUMN IF NOT EXISTS `jci_location` VARCHAR(255) NULL AFTER `role`;
