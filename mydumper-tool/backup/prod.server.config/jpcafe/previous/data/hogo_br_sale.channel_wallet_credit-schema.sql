/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `channel_wallet_credit` (
  `serial` bigint NOT NULL AUTO_INCREMENT,
  `channel_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '代理账号',
  `channel_serial` bigint unsigned NOT NULL COMMENT '代理序號',
  `symbol` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '貨幣單位',
  `parent_channel_serial` bigint unsigned NOT NULL COMMENT '上級代理序號',
  `root_channel_serial` bigint unsigned NOT NULL COMMENT '根級代理序號',
  `replenish_credit_limit` bigint NOT NULL DEFAULT '0' COMMENT '补分信用额度',
  `replenish_credit_accumulated` bigint NOT NULL DEFAULT '0' COMMENT '补分累积额度',
  `auto_replenish_threshold` bigint NOT NULL DEFAULT '0' COMMENT '自动补分水位',
  `auto_replenish_amount` bigint NOT NULL DEFAULT '0' COMMENT '自动补分额度',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '自动补分狀態 0: 關閉 1: 開啟',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`serial`) USING BTREE,
  UNIQUE KEY `uniq_channel_symbol` (`channel_serial`,`symbol`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动补分';
