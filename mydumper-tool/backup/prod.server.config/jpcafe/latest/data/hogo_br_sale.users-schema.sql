/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `users` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ID',
  `serial` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country_calling_code` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '+81',
  `phone_num` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'https://ui-avatars.com/api/?name=John+Doe&color=7F9CF5&background=EBF4FF',
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_path` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `login_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` int DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `channel_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '00000000000000000000000000000000' COMMENT '代理',
  `vip_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'VIP ID',
  `identification_number` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身分證或護照',
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名',
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓',
  `birthday` timestamp NULL DEFAULT NULL COMMENT '生日',
  `wc_user_id` int NOT NULL DEFAULT '0' COMMENT 'Wc user_id',
  PRIMARY KEY (`serial`),
  UNIQUE KEY `users_id_unique` (`id`),
  UNIQUE KEY `users_channel_id_username_unique` (`channel_id`,`username`),
  KEY `users_channel_index` (`channel_id`),
  KEY `users_vip_id_foreign` (`vip_id`),
  KEY `index_identification_number` (`identification_number`) USING BTREE,
  CONSTRAINT `users_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE SET NULL,
  CONSTRAINT `users_vip_id_foreign` FOREIGN KEY (`vip_id`) REFERENCES `vips` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
