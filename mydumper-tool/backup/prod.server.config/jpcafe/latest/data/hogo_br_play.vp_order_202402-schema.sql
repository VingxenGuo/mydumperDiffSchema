/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `vp_order_202402` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `channel_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代理ID',
  `order_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号',
  `wallet_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '錢包ID',
  `wallet_serial` bigint NOT NULL DEFAULT '0',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '玩家名',
  `origin_money` double NOT NULL COMMENT '帐变前玩家原始钱包金额',
  `money` double NOT NULL COMMENT '订单金额变化数量',
  `status` int NOT NULL COMMENT '订单状态1是成功 2是失败 3是处理中',
  `type` int NOT NULL COMMENT '订单类型0玩家上分1玩家下分2代理充值',
  `kind_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '遊戲ID',
  `game_serial` int NOT NULL DEFAULT '0' COMMENT '遊戲序號',
  `gateway_serial` int NOT NULL DEFAULT '0' COMMENT '通道序號',
  `game_user_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `currency` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '币别',
  `all_bet` double NOT NULL DEFAULT '0' COMMENT '總投注',
  `cell_score` double NOT NULL DEFAULT '0' COMMENT '有效投注',
  `revenue` double NOT NULL DEFAULT '0' COMMENT '抽水',
  `profit` double NOT NULL DEFAULT '0' COMMENT '盈利',
  `total_withdraw` double NOT NULL DEFAULT '0' COMMENT '攜入金額',
  PRIMARY KEY (`id`,`created_at`) USING BTREE,
  UNIQUE KEY `uni_idx_channelId_orderId` (`channel_id`,`order_id`,`created_at`) USING BTREE,
  KEY `idx_username_createdAt` (`username`,`created_at`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
/*!50100 PARTITION BY RANGE (unix_timestamp(`created_at`))
(PARTITION p_202403 VALUES LESS THAN (1709251200) ENGINE = InnoDB,
 PARTITION p_202404 VALUES LESS THAN (1711929600) ENGINE = InnoDB,
 PARTITION p_202405 VALUES LESS THAN (1714521600) ENGINE = InnoDB,
 PARTITION p_202406 VALUES LESS THAN (1717200000) ENGINE = InnoDB,
 PARTITION p_202407 VALUES LESS THAN (1719792000) ENGINE = InnoDB,
 PARTITION p_202408 VALUES LESS THAN (1722470400) ENGINE = InnoDB,
 PARTITION p_202409 VALUES LESS THAN (1725148800) ENGINE = InnoDB,
 PARTITION p_202410 VALUES LESS THAN (1727740800) ENGINE = InnoDB,
 PARTITION p_202411 VALUES LESS THAN (1730419200) ENGINE = InnoDB) */;
