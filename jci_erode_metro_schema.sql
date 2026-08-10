-- ============================================================
-- JCI Erode Metro — Complete Database Schema
-- Database : api_jcierodemetro
-- Generated: 2026-07-29
-- ============================================================

CREATE DATABASE IF NOT EXISTS `api_jcierodemetro`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `api_jcierodemetro`;

SET FOREIGN_KEY_CHECKS = 0;
SET sql_mode = 'NO_ENGINE_SUBSTITUTION';

-- ============================================================
-- 1. Members
-- ============================================================
CREATE TABLE IF NOT EXISTS `Members` (
  `id`                BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
  `profile_pic`       VARCHAR(255)      DEFAULT NULL,
  `user_name`         VARCHAR(255)      DEFAULT NULL,
  `membership_id`     VARCHAR(255)      DEFAULT NULL,
  `email`             VARCHAR(255)      DEFAULT NULL,
  `contact`           VARCHAR(255)      DEFAULT NULL,
  `gender`            ENUM('male','female','others') DEFAULT 'male',
  `dob`               VARCHAR(15)       DEFAULT NULL,
  `location`          TEXT              DEFAULT NULL,
  `blood_group`       ENUM('O+','O-','A+','A-','B+','B-','AB+','AB-',
                           'A1+','A2+','A1B+','A1B-','A2B+','HH') DEFAULT NULL,
  `willing_to_donate` ENUM('yes','no')  DEFAULT NULL,
  `office_name`       VARCHAR(255)      DEFAULT NULL,
  `job`               VARCHAR(255)      DEFAULT NULL,
  `sector`            VARCHAR(255)      DEFAULT NULL,
  `martial_status`    VARCHAR(255)      DEFAULT NULL,
  `role`              VARCHAR(255)      DEFAULT NULL,
  `jci_location`      VARCHAR(255)      DEFAULT NULL,
  `type`              ENUM('member','boardmember') DEFAULT 'member',
  `status`            ENUM('active','inactive') DEFAULT 'active',
  `app_access`        ENUM('view','full') DEFAULT 'view',
  `createdAt`         DATETIME          NOT NULL,
  `updatedAt`         DATETIME          NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 2. Families
-- ============================================================
CREATE TABLE IF NOT EXISTS `Families` (
  `id`           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`    BIGINT UNSIGNED DEFAULT NULL,
  `name`         VARCHAR(255)    DEFAULT NULL,
  `dob`          VARCHAR(255)    DEFAULT NULL,
  `anniversary`  VARCHAR(255)    DEFAULT NULL,
  `blood_group`  VARCHAR(255)    DEFAULT NULL,
  `relationship` VARCHAR(255)    DEFAULT NULL,
  `createdAt`    DATETIME        NOT NULL,
  `updatedAt`    DATETIME        NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_family_member`
    FOREIGN KEY (`member_id`) REFERENCES `Members` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 3. Designations
-- ============================================================
CREATE TABLE IF NOT EXISTS `Designations` (
  `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`        BIGINT UNSIGNED DEFAULT NULL,
  `designation_name` VARCHAR(255)    DEFAULT NULL,
  `designation_year` VARCHAR(255)    DEFAULT NULL,
  `createdAt`        DATETIME        NOT NULL,
  `updatedAt`        DATETIME        NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_designation_member`
    FOREIGN KEY (`member_id`) REFERENCES `Members` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 4. roleOfHonours
-- ============================================================
CREATE TABLE IF NOT EXISTS `roleOfHonours` (
  `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`           BIGINT UNSIGNED DEFAULT NULL,
  `role_of_honour_year` VARCHAR(255)    DEFAULT NULL,
  `createdAt`           DATETIME        NOT NULL,
  `updatedAt`           DATETIME        NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_roh_member`
    FOREIGN KEY (`member_id`) REFERENCES `Members` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 5. boardMembers
-- ============================================================
CREATE TABLE IF NOT EXISTS `boardMembers` (
  `id`        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` BIGINT UNSIGNED DEFAULT NULL,
  `createdAt` DATETIME        NOT NULL,
  `updatedAt` DATETIME        NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_bm_member`
    FOREIGN KEY (`member_id`) REFERENCES `Members` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 6. BloodReqs
-- ============================================================
CREATE TABLE IF NOT EXISTS `BloodReqs` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `NameOfPatient` VARCHAR(255)    DEFAULT NULL,
  `BloodGroup`    VARCHAR(255)    DEFAULT NULL,
  `NoOfUnits`     VARCHAR(255)    DEFAULT NULL,
  `Hospital_name` VARCHAR(255)    DEFAULT NULL,
  `location`      VARCHAR(255)    DEFAULT NULL,
  `Contact`       VARCHAR(255)    DEFAULT NULL,
  `Attender`      VARCHAR(255)    DEFAULT NULL,
  `VerifiedBy`    VARCHAR(255)    DEFAULT NULL,
  `createdAt`     DATETIME        NOT NULL,
  `updatedAt`     DATETIME        NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 7. businesstype
-- ============================================================
CREATE TABLE IF NOT EXISTS `businesstype` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Business_name` VARCHAR(255)    DEFAULT NULL,
  `parent_Id`     INT             DEFAULT 0,
  `createdAt`     DATETIME        NOT NULL,
  `updatedAt`     DATETIME        NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 8. notifications
-- ============================================================
CREATE TABLE IF NOT EXISTS `notifications` (
  `id`                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`             VARCHAR(255)    DEFAULT NULL,
  `description`       TEXT            DEFAULT NULL,
  `notification_type` ENUM('member','boardmember') DEFAULT NULL,
  `createdAt`         DATETIME        NOT NULL,
  `updatedAt`         DATETIME        NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 9. folderNames  (Gallery Folders)
-- ============================================================
CREATE TABLE IF NOT EXISTS `folderNames` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `folderName`  VARCHAR(255)    DEFAULT NULL,
  `title`       VARCHAR(255)    DEFAULT NULL,
  `description` TEXT            DEFAULT NULL,
  `image`       VARCHAR(255)    DEFAULT NULL,
  `status`      ENUM('active','inactive') DEFAULT 'active',
  `createdAt`   DATETIME        NOT NULL,
  `updatedAt`   DATETIME        NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 10. Admins
-- ============================================================
CREATE TABLE IF NOT EXISTS `Admins` (
  `id`        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email_id`  VARCHAR(255)    DEFAULT NULL,
  `phone`     VARCHAR(255)    DEFAULT NULL,
  `username`  VARCHAR(255)    DEFAULT NULL,
  `password`  VARCHAR(255)    DEFAULT NULL,
  `user_type` ENUM('ROOT','USER') DEFAULT 'USER',
  `status`    ENUM('active','inactive','terminated') DEFAULT 'active',
  `createdAt` DATETIME        NOT NULL,
  `updatedAt` DATETIME        NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 11. Banners
-- ============================================================
CREATE TABLE IF NOT EXISTS `Banners` (
  `id`           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `banner_image` VARCHAR(255)    DEFAULT NULL,
  `createdAt`    DATETIME        NOT NULL,
  `updatedAt`    DATETIME        NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 12. userRoles
-- ============================================================
CREATE TABLE IF NOT EXISTS `userRoles` (
  `id`        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_name` VARCHAR(255)    DEFAULT NULL,
  `createdAt` DATETIME        NOT NULL,
  `updatedAt` DATETIME        NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 13. Events
-- ============================================================
CREATE TABLE IF NOT EXISTS `Events` (
  `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `event_name`     VARCHAR(255)    DEFAULT NULL,
  `event_image`    VARCHAR(255)    DEFAULT NULL,
  `event_date`     VARCHAR(255)    DEFAULT NULL,
  `event_time`     VARCHAR(255)    DEFAULT NULL,
  `event_location` VARCHAR(255)    DEFAULT NULL,
  `event_desc`     TEXT            DEFAULT NULL,
  `createdAt`      DATETIME        NOT NULL,
  `updatedAt`      DATETIME        NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 14. eventsImages
-- ============================================================
CREATE TABLE IF NOT EXISTS `eventsImages` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `event_id`    BIGINT UNSIGNED DEFAULT NULL,
  `event_name`  VARCHAR(255)    DEFAULT NULL,
  `event_image` VARCHAR(255)    DEFAULT NULL,
  `status`      ENUM('active','inactive','terminated') DEFAULT 'active',
  `createdAt`   DATETIME        NOT NULL,
  `updatedAt`   DATETIME        NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_evimg_event`
    FOREIGN KEY (`event_id`) REFERENCES `Events` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 15. Sponsers
-- ============================================================
CREATE TABLE IF NOT EXISTS `Sponsers` (
  `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `sponser_name`        VARCHAR(255)    DEFAULT NULL,
  `sponser_image`       VARCHAR(255)    DEFAULT NULL,
  `sponser_contact`     VARCHAR(255)    DEFAULT NULL,
  `sponser_email`       VARCHAR(255)    DEFAULT NULL,
  `sponser_description` TEXT            DEFAULT NULL,
  `sponser_location`    VARCHAR(255)    DEFAULT NULL,
  `sponser_website`     VARCHAR(255)    DEFAULT NULL,
  `sponser_expiryTime`  VARCHAR(255)    DEFAULT NULL,
  `role`                ENUM('sponser','main_sponser') DEFAULT 'sponser',
  `status`              ENUM('active','inactive') DEFAULT 'active',
  `createdAt`           DATETIME        NOT NULL,
  `updatedAt`           DATETIME        NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 16. MemberAuths
-- ============================================================
CREATE TABLE IF NOT EXISTS `MemberAuths` (
  `id`                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`         BIGINT UNSIGNED DEFAULT NULL,
  `password_hash`     VARCHAR(255)    DEFAULT NULL,
  `google_id`         VARCHAR(255)    DEFAULT NULL,
  `login_email`       VARCHAR(255)    DEFAULT NULL,
  `login_phone`       VARCHAR(255)    DEFAULT NULL,
  `is_setup_complete` TINYINT(1)      DEFAULT 0,
  `createdAt`         DATETIME        NOT NULL,
  `updatedAt`         DATETIME        NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_memberauth_member` (`member_id`),
  UNIQUE KEY `uq_memberauth_google` (`google_id`),
  CONSTRAINT `fk_mauth_member`
    FOREIGN KEY (`member_id`) REFERENCES `Members` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 17. PasswordResetTokens
-- ============================================================
CREATE TABLE IF NOT EXISTS `PasswordResetTokens` (
  `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`  BIGINT UNSIGNED DEFAULT NULL,
  `token_hash` VARCHAR(255)    DEFAULT NULL,
  `type`       ENUM('email_link','identity_verify') DEFAULT NULL,
  `expires_at` DATETIME        DEFAULT NULL,
  `used`       TINYINT(1)      DEFAULT 0,
  `createdAt`  DATETIME        NOT NULL,
  `updatedAt`  DATETIME        NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_prt_member`
    FOREIGN KEY (`member_id`) REFERENCES `Members` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 18. MemberSessions
-- ============================================================
CREATE TABLE IF NOT EXISTS `MemberSessions` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`   BIGINT UNSIGNED DEFAULT NULL,
  `fcm_token`   VARCHAR(512)    DEFAULT NULL,
  `device_info` TEXT            DEFAULT NULL,
  `last_active` DATETIME        DEFAULT NULL,
  `createdAt`   DATETIME        NOT NULL,
  `updatedAt`   DATETIME        NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_session_fcm` (`fcm_token`),
  CONSTRAINT `fk_session_member`
    FOREIGN KEY (`member_id`) REFERENCES `Members` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 19. Referrals
-- ============================================================
CREATE TABLE IF NOT EXISTS `Referrals` (
  `id`                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `referrer_member_id` BIGINT UNSIGNED DEFAULT NULL,
  `linked_member_id`   BIGINT UNSIGNED DEFAULT NULL,
  `referral_type`      ENUM('self','jci_member','non_jci_member') DEFAULT NULL,
  `referred_name`      VARCHAR(255)    DEFAULT NULL,
  `referred_phone`     VARCHAR(255)    DEFAULT NULL,
  `remark`             TEXT            DEFAULT NULL,
  `referred_member_id` BIGINT UNSIGNED DEFAULT NULL,
  `status`             ENUM('pending','accepted','rejected') DEFAULT 'pending',
  `connection_type`    ENUM('non_closed_connect','completed') DEFAULT NULL,
  `connect_amount`     DECIMAL(12,2)   DEFAULT NULL,
  `createdAt`          DATETIME        NOT NULL,
  `updatedAt`          DATETIME        NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ref_referrer`
    FOREIGN KEY (`referrer_member_id`) REFERENCES `Members` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ref_linked`
    FOREIGN KEY (`linked_member_id`)   REFERENCES `Members` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ref_referred`
    FOREIGN KEY (`referred_member_id`) REFERENCES `Members` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 20. GreenChannels
-- ============================================================
CREATE TABLE IF NOT EXISTS `GreenChannels` (
  `id`        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pdf_url`   TEXT            DEFAULT NULL,
  `pdf_name`  TEXT            DEFAULT NULL,
  `createdAt` DATETIME        NOT NULL,
  `updatedAt` DATETIME        NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 21. FitnessStories
-- ============================================================
CREATE TABLE IF NOT EXISTS `FitnessStories` (
  `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`  BIGINT UNSIGNED DEFAULT NULL,
  `image_path` VARCHAR(512)    DEFAULT NULL,
  `expires_at` DATETIME        DEFAULT NULL,
  `createdAt`  DATETIME        NOT NULL,
  `updatedAt`  DATETIME        NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_fs_member`
    FOREIGN KEY (`member_id`) REFERENCES `Members` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 22. MemberNotifications
-- ============================================================
CREATE TABLE IF NOT EXISTS `MemberNotifications` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id`       BIGINT UNSIGNED DEFAULT NULL,
  `type`            ENUM('referral_received','referral_viewed','referral_responded') DEFAULT NULL,
  `title`           VARCHAR(255)    DEFAULT NULL,
  `body`            TEXT            DEFAULT NULL,
  `referral_id`     BIGINT UNSIGNED DEFAULT NULL,
  `actor_member_id` BIGINT UNSIGNED DEFAULT NULL,
  `is_read`         TINYINT(1)      DEFAULT 0,
  `createdAt`       DATETIME        NOT NULL,
  `updatedAt`       DATETIME        NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_mn_member`
    FOREIGN KEY (`member_id`)       REFERENCES `Members` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_mn_referral`
    FOREIGN KEY (`referral_id`)     REFERENCES `Referrals` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_mn_actor`
    FOREIGN KEY (`actor_member_id`) REFERENCES `Members` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
SET FOREIGN_KEY_CHECKS = 1;
-- ============================================================
-- Done — 22 tables created in database `api_jcierodemetro`
-- ============================================================
