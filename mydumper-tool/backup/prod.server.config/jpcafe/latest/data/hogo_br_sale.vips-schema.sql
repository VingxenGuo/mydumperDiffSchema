/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `vips` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ID',
  `level` int unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `channel_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '代理ID',
  `topup_total_threshold` bigint NOT NULL DEFAULT '0' COMMENT '充值总额門檻',
  `bet_total_threshold` bigint NOT NULL DEFAULT '0' COMMENT '投注总额門檻',
  `previous_day_commission_rate` decimal(3,2) NOT NULL DEFAULT '0.00' COMMENT '前一日返佣比例',
  `promote_reward_amount` bigint NOT NULL DEFAULT '0' COMMENT '晉升奖励金额',
  `daily_withdraw_count` tinyint NOT NULL DEFAULT '0' COMMENT '每日提现次数',
  `withdraw_fee_rate` decimal(3,2) NOT NULL DEFAULT '0.00' COMMENT '提现手续费率',
  `singular_withdraw_limit` bigint NOT NULL DEFAULT '0' COMMENT '单次最大提现额度',
  `monthly_free_withdraw_count` tinyint NOT NULL DEFAULT '0' COMMENT '每月免费提现次数',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `channel_id_level_unique` (`channel_id`,`level`),
  CONSTRAINT `vips_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
