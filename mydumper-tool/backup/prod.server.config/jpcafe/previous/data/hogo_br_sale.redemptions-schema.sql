/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `redemptions` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ID',
  `wallet_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '转出钱包ID',
  `dst_wallet_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '转入钱包ID',
  `deduct` bigint NOT NULL DEFAULT '0' COMMENT '转出钱包扣除金额，单位分',
  `amount` bigint NOT NULL DEFAULT '0' COMMENT '转账金额，单位分',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `redemptions_wallet_id_foreign` (`wallet_id`),
  KEY `redemptions_dst_wallet_id_foreign` (`dst_wallet_id`),
  CONSTRAINT `redemptions_dst_wallet_id_foreign` FOREIGN KEY (`dst_wallet_id`) REFERENCES `wallets` (`id`),
  CONSTRAINT `redemptions_wallet_id_foreign` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
