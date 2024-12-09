/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statisweekdata` (
  `StatisDate` varchar(50) NOT NULL,
  `NonLoginUsers` int(11) NOT NULL DEFAULT '0',
  `BetUsers` int(11) NOT NULL DEFAULT '0',
  `CellScore` bigint(20) NOT NULL DEFAULT '0',
  `Profit` bigint(20) NOT NULL DEFAULT '0',
  `Revenue` bigint(20) NOT NULL DEFAULT '0',
  `RegUsers` int(11) NOT NULL DEFAULT '0',
  `AddScoreUsers` int(11) NOT NULL DEFAULT '0',
  `PayRate` float(10,2) NOT NULL DEFAULT '0.00',
  `ConsumeRate` float(10,2) NOT NULL DEFAULT '0.00',
  `AvgCellScore` decimal(28,2) NOT NULL DEFAULT '0.00',
  `NextLogin` float(10,2) NOT NULL DEFAULT '0.00',
  `createdate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`StatisDate`) USING BTREE,
  KEY `index_statisdate` (`StatisDate`) USING BTREE,
  KEY `index_statisdate_channelid` (`StatisDate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
