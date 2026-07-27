-- Fitness Club stories (24-hour expiry)
USE jci;

CREATE TABLE IF NOT EXISTS `FitnessStory` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `image_path` varchar(512) NOT NULL,
  `expires_at` datetime NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_fitness_expires` (`expires_at`),
  KEY `idx_fitness_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
