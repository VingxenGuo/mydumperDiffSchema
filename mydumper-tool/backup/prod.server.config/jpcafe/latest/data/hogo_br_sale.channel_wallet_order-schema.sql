/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `channel_wallet_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号',
  `channel_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '代理账号',
  `channel_serial` bigint unsigned NOT NULL COMMENT '代理序號',
  `channel_wallet_serial` bigint unsigned NOT NULL COMMENT '代理錢包序號',
  `parent_channel_serial` bigint unsigned NOT NULL COMMENT '上級代理序號',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0 = 等待, 1 = 通過, 2 = 駁回, 3 = 失敗',
  `balanace` bigint NOT NULL DEFAULT '0' COMMENT '請求額度',
  `remark` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '备注',
  `fail_count` tinyint NOT NULL DEFAULT '0' COMMENT '失敗次數',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_channel_serial` (`channel_serial`) USING BTREE,
  KEY `idx_parent_channel_serial` (`parent_channel_serial`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='上分請求訂單';
