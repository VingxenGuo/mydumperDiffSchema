/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `StatisProxyScoreChange` (
  `StatisDate` date NOT NULL,
  `ChannelID` int(10) NOT NULL DEFAULT '0',
  `ChannelName` varchar(50) DEFAULT NULL,
  `PChannelName` varchar(50) DEFAULT NULL,
  `AccountingFor` int(10) DEFAULT '0',
  `BeginScore` bigint(20) DEFAULT '0',
  `EndScore` bigint(20) DEFAULT '0',
  `AddScore` bigint(20) DEFAULT '0',
  `ReduceScore` bigint(20) DEFAULT '0',
  `ElimScore` bigint(20) DEFAULT '0',
  `Profit` bigint(20) DEFAULT '0',
  `CellScore` bigint(20) DEFAULT '0',
  `Revenue` bigint(20) DEFAULT '0',
  `SumProfit` bigint(20) DEFAULT '0',
  KEY `index_StatisDate` (`StatisDate`) USING BTREE,
  KEY `index_StatisDate_ChannelID` (`StatisDate`,`ChannelID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
