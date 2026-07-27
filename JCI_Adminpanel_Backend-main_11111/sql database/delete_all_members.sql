-- =============================================================================
-- DELETE ALL MEMBERS + related details (keeps Admin, Events, Sponsors, etc.)
-- Database: jci
-- WARNING: This permanently deletes member data. Backup first if needed.
-- =============================================================================

USE `jci`;

SET FOREIGN_KEY_CHECKS = 0;

-- Auth / sessions / tokens
TRUNCATE TABLE `PasswordResetToken`;
TRUNCATE TABLE `MemberSession`;
TRUNCATE TABLE `MemberAuth`;

-- Referrals & fitness
TRUNCATE TABLE `Referral`;
TRUNCATE TABLE `FitnessStory`;

-- Member profile extras
TRUNCATE TABLE `Family`;
TRUNCATE TABLE `Designation`;
TRUNCATE TABLE `roleOfHonour`;
TRUNCATE TABLE `boardMembers`;

-- Blood requests (not always tied by FK, but clears request history)
TRUNCATE TABLE `BloodReq`;

-- Members themselves
TRUNCATE TABLE `Member`;

SET FOREIGN_KEY_CHECKS = 1;

-- Verify
SELECT 'Member' AS tbl, COUNT(*) AS rows_left FROM `Member`
UNION ALL SELECT 'MemberAuth', COUNT(*) FROM `MemberAuth`
UNION ALL SELECT 'MemberSession', COUNT(*) FROM `MemberSession`
UNION ALL SELECT 'Referral', COUNT(*) FROM `Referral`
UNION ALL SELECT 'FitnessStory', COUNT(*) FROM `FitnessStory`
UNION ALL SELECT 'Family', COUNT(*) FROM `Family`
UNION ALL SELECT 'Designation', COUNT(*) FROM `Designation`
UNION ALL SELECT 'boardMembers', COUNT(*) FROM `boardMembers`
UNION ALL SELECT 'roleOfHonour', COUNT(*) FROM `roleOfHonour`
UNION ALL SELECT 'BloodReq', COUNT(*) FROM `BloodReq`
UNION ALL SELECT 'Admin (kept)', COUNT(*) FROM `Admin`;
