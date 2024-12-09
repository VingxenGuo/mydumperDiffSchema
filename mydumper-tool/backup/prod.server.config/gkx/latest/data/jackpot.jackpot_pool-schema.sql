/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `jackpot_pool` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tier` int(11) NOT NULL COMMENT '獎金池Tier',
  `name` varchar(50) NOT NULL COMMENT '獎金池名稱',
  `auto_payout` int(1) NOT NULL DEFAULT '1' COMMENT '是否自動派獎',
  `frontend_amount` bigint(20) NOT NULL DEFAULT '0' COMMENT '前端獎池金額',
  `actual_amount` bigint(20) NOT NULL DEFAULT '0' COMMENT '實際獎池金額',
  `move_amount` bigint(20) NOT NULL DEFAULT '0' COMMENT '移動獎池金額',
  `froll` double NOT NULL DEFAULT '0' COMMENT '前端蓄水率',
  `stream_notice_rate` int(11) NOT NULL DEFAULT '0' COMMENT '直播通知触发率',
  `payout_notice_rate` int(11) NOT NULL DEFAULT '0' COMMENT '派奖通知触发率',
  `alert_notice_rate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
