/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `bridge_order_202405` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `channel_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代理ID',
  `order_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号',
  `user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '玩家ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '玩家名',
  `wallet_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '錢包ID',
  `wallet_serial` bigint NOT NULL DEFAULT '0' COMMENT '錢包序號',
  `status` int NOT NULL COMMENT '订单状态1是成功 2是失败 3是处理中',
  `type` int NOT NULL COMMENT '订单类型 0投注 1派彩 2取消下注 3FreePay 4FreeSpinBet 5FreeSpinWin',
  `game_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '遊戲ID',
  `game_serial` int NOT NULL DEFAULT '0' COMMENT '遊戲序號',
  `gateway_serial` int NOT NULL DEFAULT '0' COMMENT '通道序號',
  `game_user_no` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '牌局編號',
  `currency` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '币别',
  `origin_money` double NOT NULL COMMENT '帐变前玩家原始钱包金额',
  `amount` double NOT NULL COMMENT '订单金额',
  `total_bet` double NOT NULL DEFAULT '0' COMMENT '总投注',
  `valid_bet` double NOT NULL DEFAULT '0' COMMENT '有效投注',
  `revenue` double NOT NULL DEFAULT '0' COMMENT '抽水',
  `profit` double NOT NULL DEFAULT '0' COMMENT '盈利',
  `record_details` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci COMMENT '明细',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp(6) NULL DEFAULT NULL,
  `provider_slug` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '集成商',
  PRIMARY KEY (`id`,`created_at`) USING BTREE,
  UNIQUE KEY `uni_idx_channelId_orderId` (`channel_id`,`order_id`,`created_at`,`updated_at`) USING BTREE,
  UNIQUE KEY `uni_idx_userId_orderId` (`user_id`,`order_id`,`created_at`,`updated_at`) USING BTREE,
  KEY `idx_username_createdAt` (`username`,`created_at`) USING BTREE,
  KEY `idx_orderId_gatewaySerial_providerSlug` (`order_id`,`gateway_serial`,`provider_slug`),
  KEY `idx_gameUserNo_gatewaySerial_providerSlug` (`game_user_no`,`gateway_serial`,`provider_slug`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
/*!50100 PARTITION BY RANGE (unix_timestamp(`created_at`))
(PARTITION p_202406 VALUES LESS THAN (1717200000) ENGINE = InnoDB,
 PARTITION p_202407 VALUES LESS THAN (1719792000) ENGINE = InnoDB,
 PARTITION p_202408 VALUES LESS THAN (1722470400) ENGINE = InnoDB,
 PARTITION p_202409 VALUES LESS THAN (1725148800) ENGINE = InnoDB,
 PARTITION p_202410 VALUES LESS THAN (1727740800) ENGINE = InnoDB,
 PARTITION p_202411 VALUES LESS THAN (1730419200) ENGINE = InnoDB) */;
