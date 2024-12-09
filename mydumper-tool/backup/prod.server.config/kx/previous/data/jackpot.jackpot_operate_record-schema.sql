/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `jackpot_operate_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `currency` int(11) DEFAULT NULL COMMENT '货币类型',
  `link` varchar(190) NOT NULL COMMENT '操作',
  `cur_score` bigint(20) DEFAULT NULL COMMENT '账变前金额',
  `add_score` bigint(20) NOT NULL COMMENT '账变金额',
  `new_score` bigint(20) DEFAULT NULL COMMENT '账变后金额',
  `order_ip` varchar(50) NOT NULL COMMENT '操作IP',
  `create_user` varchar(50) NOT NULL COMMENT '操作帳號',
  `pool_tier` int(11) NOT NULL COMMENT '獎金池Tier',
  `create_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '創建時間',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
