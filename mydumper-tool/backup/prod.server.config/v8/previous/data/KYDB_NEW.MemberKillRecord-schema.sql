/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `MemberKillRecord` (
  `MID` int(11) NOT NULL AUTO_INCREMENT,
  `Account` varchar(190) DEFAULT NULL,
  `PlanKillScore` bigint(20) DEFAULT NULL,
  `TodayKillScore` bigint(20) DEFAULT NULL,
  `AllKillScore` bigint(20) DEFAULT NULL,
  `KillStatus` int(11) DEFAULT NULL,
  `Cause` varchar(500) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`MID`),
  UNIQUE KEY `index_Account` (`Account`),
  KEY `key_KillStatus` (`KillStatus`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
