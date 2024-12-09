/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_multibet_analyze` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(190) DEFAULT NULL,
  `type` int(11) NOT NULL COMMENT '0:进入多桌下注,1:透过多桌下注进行下注',
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_account` (`account`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;
