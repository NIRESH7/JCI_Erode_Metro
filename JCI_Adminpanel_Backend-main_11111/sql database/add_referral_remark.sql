-- Add optional remark/notes on referrals (Give Referral Step 3)
ALTER TABLE `Referral`
  ADD COLUMN IF NOT EXISTS `remark` TEXT NULL AFTER `referred_phone`;
