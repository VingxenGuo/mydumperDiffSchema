/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `logos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `channel_serial` bigint unsigned NOT NULL COMMENT '代理序號',
  `type` int unsigned NOT NULL DEFAULT '0' COMMENT '0: 網頁, 1: 手機',
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '標題',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '狀態: 0關閉, 1開啟',
  `img_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '圖片名稱',
  `created_user` varchar(120) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作人',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_updated_at` (`channel_serial`,`updated_at`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Logo設置';
