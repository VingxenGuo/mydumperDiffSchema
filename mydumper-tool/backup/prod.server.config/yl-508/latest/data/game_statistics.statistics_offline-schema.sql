/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_offline` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(255) NOT NULL COMMENT '玩家账号',
  `agent` int(11) NOT NULL COMMENT '代理编号',
  `ip` varchar(255) NOT NULL COMMENT '离线ip',
  `createdate` datetime DEFAULT NULL COMMENT '离线时间',
  `carrieroperator` varchar(255) DEFAULT NULL COMMENT '运营商',
  `city` varchar(255) DEFAULT NULL COMMENT '城市',
  `province` varchar(255) DEFAULT NULL COMMENT '省份',
  `country` varchar(255) DEFAULT NULL COMMENT '国家',
  PRIMARY KEY (`id`),
  KEY `index_createdate` (`createdate`) USING BTREE,
  KEY `index_createdate_agent` (`createdate`,`agent`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
