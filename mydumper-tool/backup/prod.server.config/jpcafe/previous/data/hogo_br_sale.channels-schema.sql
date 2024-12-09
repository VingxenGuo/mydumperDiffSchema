/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `channels` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ID',
  `parent_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '00000000000000000000000000000000' COMMENT '上级代理',
  `root_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '根级代理',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '代理名称',
  `auth_parameter` json DEFAULT NULL COMMENT '設定參數為json',
  `promotion_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '推廣網址',
  `promotion_url_type` int DEFAULT '0',
  `cooperation_func` int DEFAULT '2' COMMENT '合作模式 1=OTP,2=免驗證',
  `serial` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '代理商號',
  `symbol` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BRL' COMMENT '貨幣單位',
  `language` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `theme` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'viva' COMMENT '主題: viva, alpha',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '启用状态 0:停用 1:启用',
  `status_maintain` tinyint NOT NULL DEFAULT '0' COMMENT '维护状态 0:运行 1:维护',
  `status_auto_review` tinyint NOT NULL DEFAULT '0' COMMENT '自動審核状态 0:运行 1:维护',
  `status_account_release` tinyint NOT NULL DEFAULT '0' COMMENT '自動審核状态 0:运行 1:维护',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  `group` tinyint NOT NULL DEFAULT '0' COMMENT '分群 0=admin 1=jpcafe 2=tony',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`serial`),
  UNIQUE KEY `channels_id_unique` (`id`),
  UNIQUE KEY `channels_name_unique` (`name`),
  KEY `channels_parent_id_index` (`parent_id`),
  KEY `channels_root_id_index` (`root_id`),
  CONSTRAINT `channels_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
