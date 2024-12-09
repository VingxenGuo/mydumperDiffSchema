/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `riskControlNotify` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `notifyTime` datetime NOT NULL,
  `setId` tinyint(2) unsigned NOT NULL,
  `content` json NOT NULL,
  `mark` tinyint(1) unsigned NOT NULL,
  `analysis` varchar(256) DEFAULT NULL,
  `solution` varchar(256) DEFAULT NULL,
  `operator` varchar(30) DEFAULT NULL,
  `operatingTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
