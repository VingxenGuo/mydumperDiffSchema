/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `channel_wallet_statistics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `wallet_serial` bigint NOT NULL DEFAULT '0' COMMENT 'serial',
  `topup_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT '系统上分次数',
  `topup_score` bigint NOT NULL DEFAULT '0' COMMENT '系统上分金额',
  `topup_at` datetime DEFAULT NULL COMMENT '最後系统上分時間',
  `withdrawal_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT '系统下分次数',
  `withdrawal_score` bigint NOT NULL DEFAULT '0' COMMENT '系统下分金额',
  `withdraw_at` datetime DEFAULT NULL COMMENT '最後系统下分時間',
  `channel_topup_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT '对代理上分次数',
  `channel_topup_score` bigint NOT NULL DEFAULT '0' COMMENT '对代理上分金额',
  `channel_topup_at` datetime DEFAULT NULL COMMENT '最後对代理上分時間',
  `channel_withdrawal_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT '对代理下分次数',
  `channel_withdrawal_score` bigint NOT NULL DEFAULT '0' COMMENT '对代理下分金额',
  `channel_withdraw_at` datetime DEFAULT NULL COMMENT '最後对代理下分時間',
  `user_topup_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT '对用户上分次数',
  `user_topup_score` bigint NOT NULL DEFAULT '0' COMMENT '对用户上分金额',
  `user_topup_at` datetime DEFAULT NULL COMMENT '最後对用户上分時間',
  `user_withdrawal_count` bigint unsigned NOT NULL DEFAULT '0' COMMENT '对用户下分次数',
  `user_withdrawal_score` bigint NOT NULL DEFAULT '0' COMMENT '对用户下分金额',
  `user_withdraw_at` datetime DEFAULT NULL COMMENT '最後对用户下分時間',
  `topup_application_count` bigint NOT NULL DEFAULT '0' COMMENT '申请上分次数',
  `topup_application_score` bigint NOT NULL DEFAULT '0' COMMENT '申请上分金额',
  `inflow` bigint NOT NULL DEFAULT '0' COMMENT '流入金额',
  `outflow` bigint NOT NULL DEFAULT '0' COMMENT '流出金额',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `channel_wallets_serial_unique` (`wallet_serial`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
