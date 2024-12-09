/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `withdrawals` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号',
  `wallet_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '錢包ID',
  `bank_account_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '银行帳户ID',
  `order_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '第三方订单编号',
  `gateway_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通道ID',
  `amount` bigint NOT NULL COMMENT '提现金额，单位分',
  `fee` bigint DEFAULT NULL COMMENT '手续费，单位分',
  `payout` bigint DEFAULT NULL COMMENT '实付金额，单位分',
  `response` json DEFAULT NULL COMMENT '第三方返回数据',
  `admin_id` bigint DEFAULT NULL COMMENT '审核人员',
  `verified_at` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态 0:待审核 1:审核通过 2:审核拒绝 3:提現代付 4:提现成功 5:提现失败',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `withdrawals_wallet_id_foreign` (`wallet_id`),
  KEY `withdrawals_gateway_id_foreign` (`gateway_id`),
  KEY `withdrawals_bank_account_id_foreign` (`bank_account_id`),
  CONSTRAINT `withdrawals_bank_account_id_foreign` FOREIGN KEY (`bank_account_id`) REFERENCES `bank_accounts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `withdrawals_gateway_id_foreign` FOREIGN KEY (`gateway_id`) REFERENCES `gateways` (`id`),
  CONSTRAINT `withdrawals_wallet_id_foreign` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
