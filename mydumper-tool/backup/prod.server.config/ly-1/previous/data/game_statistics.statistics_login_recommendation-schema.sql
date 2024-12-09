/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_login_recommendation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(190) DEFAULT NULL,
  `agent` int(11) NOT NULL COMMENT '代理编号',
  `fromgameid` int(10) NOT NULL COMMENT 'from GameID',
  `togameid` int(10) NOT NULL COMMENT 'to GameID',
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_createdate` (`createdate`) USING BTREE,
  KEY `index_createdate_account` (`createdate`,`account`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;
