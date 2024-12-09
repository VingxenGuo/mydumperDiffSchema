/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_account_sites` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(190) DEFAULT NULL COMMENT '玩家账号',
  `site_url` longtext COMMENT '设备平台0:pc,1:mobile',
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_createdate` (`createdate`) USING BTREE,
  KEY `index_createdate_agent` (`createdate`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
