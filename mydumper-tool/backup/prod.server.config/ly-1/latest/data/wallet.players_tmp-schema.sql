/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `players_tmp` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(190) NOT NULL COMMENT '会员账号',
  `currency` varchar(20) NOT NULL COMMENT '币别',
  `money` bigint(20) NOT NULL DEFAULT '0' COMMENT '钱包余额',
  `updateDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `index_account_currency` (`name`,`currency`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
