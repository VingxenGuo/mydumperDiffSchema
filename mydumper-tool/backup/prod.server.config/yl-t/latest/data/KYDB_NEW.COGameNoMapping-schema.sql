/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `COGameNoMapping` (
  `GameNo` varchar(190) COLLATE utf8mb4_bin NOT NULL,
  `CurScore` bigint(20) DEFAULT NULL,
  `GameID` int(11) DEFAULT NULL,
  `GameName` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `GameStartTime` timestamp NULL DEFAULT NULL,
  `BetOrderId` text COLLATE utf8mb4_bin,
  `Account` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `companyid` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `Status` int(11) DEFAULT '0' COMMENT '状态 0投注，1已派獎',
  `GameEndTime` timestamp NULL DEFAULT NULL,
  `currency` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '币别',
  PRIMARY KEY (`GameNo`),
  KEY `GameNoAndGameEndTime` (`GameNo`,`GameEndTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
