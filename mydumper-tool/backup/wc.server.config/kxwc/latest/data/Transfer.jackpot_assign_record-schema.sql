/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `jackpot_assign_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL COMMENT '代理ID',
  `assign_user` varchar(50) NOT NULL COMMENT '指派玩家帳號',
  `pool_tier` int(11) NOT NULL COMMENT '獎金池Tier',
  `order_ip` varchar(50) NOT NULL COMMENT '操作IP',
  `create_user` varchar(50) NOT NULL COMMENT '操作帳號',
  `assign_status` int(11) NOT NULL COMMENT '指派狀態:0成功 1處理中 2異常',
  `error_code` int(11) DEFAULT NULL COMMENT '錯誤代碼',
  `win_amount` bigint(20) DEFAULT NULL COMMENT '獲得金額',
  `payout_record_id` bigint(20) DEFAULT NULL COMMENT '關聯 派獎記錄ID',
  `create_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '創建時間',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
