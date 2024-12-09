/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `channel_wallet_ledgers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `wallet_serial` bigint NOT NULL DEFAULT '0' COMMENT '錢包serial',
  `channel_serial` bigint NOT NULL DEFAULT '0' COMMENT '交易者serial,只为系统或代理',
  `trans_serial` bigint NOT NULL DEFAULT '0' COMMENT '交易对象serial,可为代理或用户',
  `order_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '订单编号',
  `score` bigint NOT NULL DEFAULT '0' COMMENT '交易金额，单位分',
  `balance_before` bigint NOT NULL DEFAULT '0' COMMENT '交易前余额，单位分',
  `balance_remain` bigint NOT NULL DEFAULT '0' COMMENT '交易后余额，单位分',
  `type` int NOT NULL DEFAULT '1' COMMENT '帳变類型 1系统上分-代理,2系统下分-代理,3系统上分-用户,4系统下分-用户',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  `created_serial` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作人serial',
  `created_user` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作人名称',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_wallet_serial` (`wallet_serial`) USING BTREE,
  KEY `idx_channel_serial` (`channel_serial`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
