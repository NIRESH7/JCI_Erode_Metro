-- =============================================================================
-- Fix relative profile_pic paths for admin panel (live)
-- Admin is on adminpanel.jcierodemetro.com; images are on api.jcierodemetro.com
-- Relative /images/x.jpg would load from the WRONG host — prefix the API base.
--
-- ALSO REQUIRED: upload files 1.png … 17.jpg to live:
--   .../src/core/images/
-- Verify: https://api.jcierodemetro.com/images/8.jpg  (must not be 404)
-- =============================================================================

USE `api_jcierodemetro`;

UPDATE `Member`
SET `profile_pic` = CONCAT('https://api.jcierodemetro.com', `profile_pic`)
WHERE `profile_pic` LIKE '/images/%';

SELECT id, user_name, profile_pic
FROM `Member`
ORDER BY id;
