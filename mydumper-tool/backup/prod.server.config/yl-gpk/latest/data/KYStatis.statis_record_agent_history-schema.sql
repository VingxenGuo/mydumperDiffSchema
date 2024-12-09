/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_record_agent_history` (
  `ChannelID` int(11) NOT NULL,
  `WinGold` bigint(20) DEFAULT '0' COMMENT '赢钱',
  `LostGold` bigint(20) DEFAULT '0' COMMENT '输钱',
  `CellScore` bigint(20) DEFAULT '0' COMMENT '有效投注',
  `Revenue` bigint(20) DEFAULT '0',
  `WinNum` int(11) DEFAULT '0' COMMENT '赢钱局数',
  `LostNum` bigint(20) DEFAULT NULL,
  `ActiveUsers` int(11) DEFAULT '0',
  `currency` varchar(20) NOT NULL COMMENT '幣別',
  `exchangeRate` decimal(20,5) NOT NULL COMMENT '汇率',
  PRIMARY KEY (`ChannelID`,`currency`) USING BTREE,
  KEY `statis_record_agent_history_ChannelID_IDX` (`ChannelID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
