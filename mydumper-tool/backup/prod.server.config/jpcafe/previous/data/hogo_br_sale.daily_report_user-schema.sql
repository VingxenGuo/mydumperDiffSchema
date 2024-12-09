/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `daily_report_user` (
  `time` date NOT NULL COMMENT '日期',
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用戶ID',
  `symbol` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '貨幣單位',
  `topup` bigint DEFAULT '0' COMMENT '現金充值',
  `withdrawal` bigint DEFAULT '0' COMMENT '現金提款',
  `sys_cashier` bigint DEFAULT '0' COMMENT '系統上下分',
  `token_purchase` bigint DEFAULT '0' COMMENT '買luck幣金額',
  `token_receive` bigint DEFAULT '0' COMMENT '得到luck幣金額',
  `roulette` bigint DEFAULT '0' COMMENT '大轉盤投注',
  `roulette_reward` bigint DEFAULT '0' COMMENT '大轉盤中獎',
  `sys_cashier_bonus` bigint DEFAULT '0' COMMENT '后台赠金',
  `commission_withdraw` bigint DEFAULT '0' COMMENT '团队奖励转出',
  `commission_redemption` bigint DEFAULT '0' COMMENT '团队奖励转入',
  `sys_cashier_salary` bigint DEFAULT '0' COMMENT '工资',
  `promotion_chest` bigint DEFAULT '0' COMMENT 'VIP寶箱',
  `invitation_chest` bigint DEFAULT '0' COMMENT '邀請寶箱',
  `bonus_topup_initial` bigint DEFAULT '0' COMMENT '首充赠送',
  `bonus_topup_fever` bigint DEFAULT '0' COMMENT '充值赠送',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`time`,`user_id`,`symbol`),
  KEY `index_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
