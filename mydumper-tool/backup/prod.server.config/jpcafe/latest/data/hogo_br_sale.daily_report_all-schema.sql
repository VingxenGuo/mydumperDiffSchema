/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `daily_report_all` (
  `time` date NOT NULL COMMENT '日期',
  `channel_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '代理ID',
  `symbol` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '貨幣單位',
  `newuser` int DEFAULT '0' COMMENT '注册人數',
  `activeuser` int DEFAULT '0' COMMENT '活跃用户',
  `newaccess` int DEFAULT '0' COMMENT '新用户访问',
  `paymoney` bigint DEFAULT '0' COMMENT '充值金额',
  `peypeople` int DEFAULT '0' COMMENT '充值人数',
  `newusermoney` bigint DEFAULT '0' COMMENT '首存金额',
  `newuserpeople` int DEFAULT '0' COMMENT '首存人数',
  `reflectnum` int DEFAULT '0' COMMENT '提款人数',
  `reflectmoney` bigint DEFAULT '0' COMMENT '提款金额',
  `reflectsalary` bigint DEFAULT '0' COMMENT '博主提现(工资)',
  `reflectreward` bigint DEFAULT '0' COMMENT '团队提现(团队奖励)',
  `profit` bigint DEFAULT '0' COMMENT '利润',
  `payfees` bigint DEFAULT '0' COMMENT '充值手续费',
  `reflectfees` bigint DEFAULT '0' COMMENT '充值手续费',
  `yesterdaypaypeople` int DEFAULT '0' COMMENT '昨日充值人数',
  `repaypeople` int DEFAULT '0' COMMENT '复冲人数',
  `updated_at` timestamp NULL DEFAULT (now()),
  `wallet_paymoney` bigint DEFAULT '0' COMMENT '後台充值金额 根據wallet_ledgers表抓取的資料',
  `wallet_paypeople` int DEFAULT '0' COMMENT '後台充值人数 根據wallet_ledgers表抓取的資料',
  `wallet_reflectsalary` bigint DEFAULT '0' COMMENT '後台提款金额 根據wallet_ledgers表抓取的資料',
  `wallet_reflectnum` int DEFAULT '0' COMMENT '後台提款人数 根據wallet_ledgers表抓取的資料',
  `wallet_user_profit` bigint DEFAULT '0' COMMENT '會員輸贏 根據wallet_ledgers表抓取的資料',
  `wallet_user_loss` bigint DEFAULT '0' COMMENT '會員投注 根據wallet_ledgers表抓取的資料',
  `wallet_channel_gain` bigint DEFAULT '0' COMMENT '代理下發總點數  根據wallet_ledgers表抓取的資料',
  `wallet_channel_all_profit` bigint DEFAULT '0' COMMENT '旗下總輸贏  根據wallet_ledgers表抓取的資料',
  PRIMARY KEY (`time`,`channel_id`,`symbol`),
  KEY `index_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
