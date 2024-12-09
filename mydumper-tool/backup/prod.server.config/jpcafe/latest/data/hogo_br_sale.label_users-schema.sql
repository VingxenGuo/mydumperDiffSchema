/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `label_users` (
  `label_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '標籤ID',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `label_id_user_id_unique` (`label_id`,`user_id`),
  KEY `label_users_user_id_foreign` (`user_id`),
  CONSTRAINT `label_users_label_id_foreign` FOREIGN KEY (`label_id`) REFERENCES `labels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `label_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
