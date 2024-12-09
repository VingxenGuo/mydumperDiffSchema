/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `rely_bet` (
  `statis_date` date NOT NULL COMMENT '統計日期',
  `game_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '遊戲編號',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '玩家編號',
  `wallet_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '錢包編號',
  `gateway_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '廠商編號',
  `channel_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '代理編號',
  `sum_consume` bigint DEFAULT '0' COMMENT '總打碼',
  `sum_reward` bigint DEFAULT '0' COMMENT '總獲利',
  `sum_num` int DEFAULT '0' COMMENT '總局数',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `rely_bet_UN` (`statis_date`,`game_id`,`user_id`,`wallet_id`,`gateway_id`,`channel_id`),
  KEY `rely_bet_statis_date_index` (`statis_date`),
  KEY `rely_bet_statis_date_user_id_index` (`statis_date`,`user_id`),
  KEY `rely_bet_statis_date_gateway_id_game_id_index` (`statis_date`,`gateway_id`,`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY RANGE (to_days(`statis_date`))
(PARTITION p_202401 VALUES LESS THAN (739251) ENGINE = InnoDB,
 PARTITION p_202402 VALUES LESS THAN (739282) ENGINE = InnoDB,
 PARTITION p_202403 VALUES LESS THAN (739311) ENGINE = InnoDB,
 PARTITION p_202404 VALUES LESS THAN (739342) ENGINE = InnoDB,
 PARTITION p_202405 VALUES LESS THAN (739372) ENGINE = InnoDB,
 PARTITION p_202406 VALUES LESS THAN (739403) ENGINE = InnoDB,
 PARTITION p_202407 VALUES LESS THAN (739433) ENGINE = InnoDB,
 PARTITION p_202408 VALUES LESS THAN (739464) ENGINE = InnoDB,
 PARTITION p_202409 VALUES LESS THAN (739495) ENGINE = InnoDB,
 PARTITION p_202410 VALUES LESS THAN (739525) ENGINE = InnoDB,
 PARTITION p_202411 VALUES LESS THAN (739556) ENGINE = InnoDB,
 PARTITION p_202412 VALUES LESS THAN (739586) ENGINE = InnoDB,
 PARTITION p_202501 VALUES LESS THAN (739617) ENGINE = InnoDB) */;
