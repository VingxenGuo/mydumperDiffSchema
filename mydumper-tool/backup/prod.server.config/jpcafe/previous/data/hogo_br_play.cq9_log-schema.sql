/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `cq9_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `wallet_id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '錢包ID',
  `event_time` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '事件時間 格式為 RFC3339',
  `gamehall` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '遊戲廠商代號',
  `gamecode` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '遊戲代號',
  `roundid` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '注單號(為唯一值)',
  `amount` bigint NOT NULL DEFAULT '0' COMMENT '下注金額',
  `mtcode` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '交易代碼',
  `session` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '交易ID',
  `platform` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '交易ID',
  `bet_return` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
  `status` int NOT NULL DEFAULT '1' COMMENT '状态 1提交 2 完成 3撤回',
  `refund_return` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `result_mtcode` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '獲獎交易代碼(data內第一筆)',
  `result_data` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `result_amount` bigint NOT NULL DEFAULT '0',
  `result_time` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '系統成單時間 格式為 RFC3339',
  `freegame` int NOT NULL DEFAULT '0',
  `bonus` int NOT NULL DEFAULT '0',
  `luckydraw` int NOT NULL DEFAULT '0',
  `jackpot` decimal(30,2) NOT NULL DEFAULT '0.00',
  `jackpotcontribution` decimal(30,8) NOT NULL DEFAULT '0.00000000',
  `freeticket` int NOT NULL DEFAULT '0',
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
