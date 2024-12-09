/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `referral_statistics` (
  `referral_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '推荐关系id',
  `bet` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐用戶累積投注金额',
  `bets` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐用戶累積投注次数',
  `win` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐用戶累積獲利金额',
  `topup` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐用戶累積充值金额',
  `topups` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐用戶累積充值次数',
  `topup_payout` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐用戶累積充值实付金额',
  `topup_fee` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐用戶累積充值手续费',
  `withdrawal` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐用戶累積提现金额',
  `withdrawals` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐用戶累積提现次数',
  `withdrawal_payout` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐用戶累積提现实付金额',
  `withdrawal_fee` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐用戶累積提现手续费',
  `referrals` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐人数',
  `referrals_effective` bigint NOT NULL DEFAULT '0' COMMENT '直屬有效推荐人数',
  `referrals_with_bets` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐人数中有投注的人数',
  `referrals_with_topups` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐人数中有充值的人数',
  `referrals_with_withdrawals` bigint NOT NULL DEFAULT '0' COMMENT '直屬推荐人数中有提现的人数',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`referral_id`),
  CONSTRAINT `referral_statistics_referral_id_foreign` FOREIGN KEY (`referral_id`) REFERENCES `referrals` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
