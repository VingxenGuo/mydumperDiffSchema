/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `finance_dielivery_list_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `StatisDate` varchar(7) NOT NULL,
  `ChannelID` int(11) NOT NULL DEFAULT '0',
  `ReceiveChannelID` int(11) NOT NULL DEFAULT '0',
  `LevelID` int(11) NOT NULL DEFAULT '0',
  `ChannelName` varchar(100) NOT NULL,
  `NickName` varchar(100) DEFAULT NULL,
  `AccountingFor` decimal(11,2) DEFAULT '0.00',
  `CellScore` bigint(20) DEFAULT '0',
  `Profit` bigint(20) DEFAULT '0',
  `SumProfit` bigint(20) DEFAULT '0',
  `TimeZone` int(11) DEFAULT '0',
  `SpecialMoney` bigint(20) DEFAULT '0',
  `Remark` text,
  `Status` int(11) DEFAULT '0',
  `CreateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CheckTime` datetime DEFAULT NULL,
  `SendTime` datetime DEFAULT NULL,
  `UpdateTime` datetime DEFAULT CURRENT_TIMESTAMP,
  `category` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_StatisDate_channelid` (`StatisDate`,`ChannelID`,`category`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;
