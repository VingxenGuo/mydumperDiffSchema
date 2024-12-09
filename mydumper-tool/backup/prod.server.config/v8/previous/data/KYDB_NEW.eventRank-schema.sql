/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `eventRank` (
  `eventId` tinyint(3) unsigned NOT NULL,
  `agentId` int(10) unsigned NOT NULL,
  `param` blob NOT NULL,
  `startTime` datetime NOT NULL,
  `endTime` datetime NOT NULL,
  `updateTime` datetime NOT NULL,
  `robot` blob NOT NULL,
  PRIMARY KEY (`eventId`,`agentId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
