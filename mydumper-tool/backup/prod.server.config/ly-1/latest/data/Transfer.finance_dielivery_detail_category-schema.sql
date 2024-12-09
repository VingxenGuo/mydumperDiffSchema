/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `finance_dielivery_detail_category` (
  `StatisDate` date NOT NULL,
  `ChannelID` int(11) NOT NULL DEFAULT '0',
  `ChannelName` varchar(100) DEFAULT NULL,
  `NickName` varchar(100) DEFAULT NULL,
  `AccountingFor` decimal(11,2) DEFAULT '0.00',
  `CellScore` bigint(20) DEFAULT '0',
  `Profit` bigint(20) DEFAULT '0',
  `SumProfit` bigint(20) DEFAULT '0',
  `TimeZone` int(11) DEFAULT '0',
  `CreateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `category` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`StatisDate`,`ChannelID`,`category`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;
