/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `pg_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `wallet_id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '錢包ID',
  `game_id` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '游戏编码',
  `transaction_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `bet_amount` bigint NOT NULL DEFAULT '0' COMMENT 'bet金额',
  `win_amount` bigint NOT NULL DEFAULT '0' COMMENT 'win金额',
  `transfer_amount` bigint NOT NULL DEFAULT '0' COMMENT '調整金额',
  `bet_details` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '数据',
  `before_result` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '提交前',
  `result_return` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '提交后',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态 1提交 2 完成 3撤回',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `index_id_creatime` (`id`,`created_at`),
  KEY `index_transactionId` (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
/*!50100 PARTITION BY RANGE (unix_timestamp(`created_at`))
(PARTITION p_202401 VALUES LESS THAN (1704067200) ENGINE = InnoDB,
 PARTITION p_202402 VALUES LESS THAN (1706745600) ENGINE = InnoDB,
 PARTITION p_202403 VALUES LESS THAN (1709251200) ENGINE = InnoDB,
 PARTITION p_202404 VALUES LESS THAN (1711929600) ENGINE = InnoDB) */;
