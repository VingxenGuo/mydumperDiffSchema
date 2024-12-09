/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `vp_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `wallet_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '錢包ID',
  `username` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '玩家帳號',
  `channel_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代理ID',
  `game_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '游戏编码',
  `room_code` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '房間編碼',
  `record_details` json DEFAULT NULL COMMENT '明细',
  `cell_score` bigint DEFAULT NULL COMMENT '有效投注额',
  `all_bet` bigint DEFAULT NULL COMMENT '总投注',
  `profit` bigint DEFAULT NULL COMMENT '输赢金额',
  `revenue` int DEFAULT NULL COMMENT '抽水',
  `game_user_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `game_start_time` datetime DEFAULT NULL COMMENT '游戏开始时间',
  `game_end_time` timestamp NOT NULL COMMENT '游戏结束时间',
  `language` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '语言',
  `currency` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '币别',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态 1提交 2 完成 3撤回',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`game_end_time`) USING BTREE,
  UNIQUE KEY `uni_idx_GameUserNO_GameEndTime` (`game_user_no`,`game_end_time`) USING BTREE,
  KEY `idx_roomCode` (`room_code`) USING BTREE,
  KEY `idx_user_id_GameEndTime` (`username`,`game_end_time`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
/*!50100 PARTITION BY RANGE (unix_timestamp(`game_end_time`))
(PARTITION p_202403 VALUES LESS THAN (1709251200) ENGINE = InnoDB,
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
