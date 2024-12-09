/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `wallet_statistics` (
  `wallet_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ID',
  `withdrawals` bigint unsigned NOT NULL DEFAULT '0' COMMENT '提现次数',
  `withdrawal` bigint NOT NULL DEFAULT '0' COMMENT '提现金额',
  `withdrawal_fee` bigint NOT NULL DEFAULT '0' COMMENT '提现手续费',
  `withdrawal_payout` bigint NOT NULL DEFAULT '0' COMMENT '提现实付金额',
  `withdraw_at` datetime DEFAULT NULL COMMENT '最後提现時間',
  `topups` bigint unsigned NOT NULL DEFAULT '0' COMMENT '充值次数',
  `topup_fee` bigint NOT NULL DEFAULT '0' COMMENT '充值手续费',
  `topup_payout` bigint NOT NULL DEFAULT '0' COMMENT '充值实付金额',
  `topup` bigint NOT NULL DEFAULT '0' COMMENT '充值金额',
  `topup_at` datetime DEFAULT NULL COMMENT '最後充值時間',
  `bets` bigint unsigned NOT NULL DEFAULT '0' COMMENT '投注次数',
  `bet` bigint NOT NULL DEFAULT '0' COMMENT '投注金额',
  `bet_at` datetime DEFAULT NULL COMMENT '最後下注時間',
  `win` bigint NOT NULL DEFAULT '0' COMMENT '獲利金额',
  `inflow` bigint NOT NULL DEFAULT '0' COMMENT '流入金额',
  `outflow` bigint NOT NULL DEFAULT '0' COMMENT '流出金额',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `wallet_statistics_wallet_id_unique` (`wallet_id`),
  CONSTRAINT `wallet_statistics_wallet_id_foreign` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
