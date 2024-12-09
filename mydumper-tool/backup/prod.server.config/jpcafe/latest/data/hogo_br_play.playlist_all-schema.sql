/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `playlist_all` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `game_user_no` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '牌局編號',
  `gateway_id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '通道ID',
  `gateway_slug` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '厂商名称',
  `game_id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '游戏ID',
  `game_nick_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '游戏昵称',
  `channel_id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '代理ID',
  `user_id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '玩家ID',
  `username` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '玩家名称',
  `wallet_id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL COMMENT '錢包ID',
  `currency` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '币别',
  `origin_money` double NOT NULL COMMENT '帐变前玩家原始钱包金额',
  `total_bet` double NOT NULL DEFAULT '0' COMMENT '总投注',
  `valid_bet` double NOT NULL DEFAULT '0' COMMENT '有效投注',
  `revenue` double NOT NULL DEFAULT '0' COMMENT '抽水',
  `profit` double NOT NULL DEFAULT '0' COMMENT '盈利',
  `after_money` double NOT NULL COMMENT '帐变後玩家钱包金额',
  `status` int NOT NULL COMMENT '订单状态 0=处理中 1=完成',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '游戏结束时间',
  `bet_num` int NOT NULL DEFAULT '0' COMMENT '投注次數,第一次投注不計',
  `pay_num` int NOT NULL DEFAULT '0' COMMENT '派彩次數,第一次派彩不計',
  `provider_slug` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '集成商',
  KEY `index_userId` (`user_id`),
  KEY `index_gameId` (`game_id`),
  KEY `idx_gameUserNo_userId_gatewaySlug_providerSlug` (`game_user_no`,`user_id`,`gateway_slug`,`provider_slug`) USING BTREE,
  KEY `index_id` (`id`) USING BTREE,
  KEY `index_updatedAt_DESC` (`updated_at` DESC) USING BTREE,
  KEY `index_gatewaySlug_updatedAt` (`gateway_slug`,`updated_at`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci
/*!50100 PARTITION BY RANGE (unix_timestamp(`created_at`))
(PARTITION p_202410 VALUES LESS THAN (1727740800) ENGINE = InnoDB,
 PARTITION p_202411 VALUES LESS THAN (1730419200) ENGINE = InnoDB,
 PARTITION p_202412 VALUES LESS THAN (1733011200) ENGINE = InnoDB,
 PARTITION p_202501 VALUES LESS THAN (1735689600) ENGINE = InnoDB) */;
