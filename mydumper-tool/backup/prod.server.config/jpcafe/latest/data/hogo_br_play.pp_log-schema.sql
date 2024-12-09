/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `pp_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `wallet_id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `game_id` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `round_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `provider_id` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `bet_hash` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `bet_amount` bigint NOT NULL DEFAULT '0',
  `bet_reference` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `bet_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `bet_round_details` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `bet_return` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `status` int NOT NULL DEFAULT '1',
  `refund_return` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `result_hash` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `result_amount` bigint NOT NULL DEFAULT '0',
  `result_reference` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `result_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `result_round_details` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `result_return` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `index_id_creatime` (`id`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
/*!50100 PARTITION BY RANGE (unix_timestamp(`created_at`))
(PARTITION p_202401 VALUES LESS THAN (1704067200) ENGINE = InnoDB,
 PARTITION p_202402 VALUES LESS THAN (1706745600) ENGINE = InnoDB,
 PARTITION p_202403 VALUES LESS THAN (1709251200) ENGINE = InnoDB,
 PARTITION p_202404 VALUES LESS THAN (1711929600) ENGINE = InnoDB,
 PARTITION p_202405 VALUES LESS THAN (1714521600) ENGINE = InnoDB,
 PARTITION p_202406 VALUES LESS THAN (1717200000) ENGINE = InnoDB,
 PARTITION p_202407 VALUES LESS THAN (1719792000) ENGINE = InnoDB,
 PARTITION p_202408 VALUES LESS THAN (1722470400) ENGINE = InnoDB,
 PARTITION p_202409 VALUES LESS THAN (1725148800) ENGINE = InnoDB,
 PARTITION p_202410 VALUES LESS THAN (1727740800) ENGINE = InnoDB,
 PARTITION p_202411 VALUES LESS THAN (1730419200) ENGINE = InnoDB,
 PARTITION p_202412 VALUES LESS THAN (1733011200) ENGINE = InnoDB,
 PARTITION p_202501 VALUES LESS THAN (1735689600) ENGINE = InnoDB) */;
