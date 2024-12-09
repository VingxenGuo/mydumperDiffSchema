/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `gameRecordInfo` (
  `businessId` varchar(100) NOT NULL COMMENT '訂單號',
  `currency` varchar(10) NOT NULL COMMENT '幣種',
  `language` varchar(10) NOT NULL COMMENT '語系',
  PRIMARY KEY (`businessId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
