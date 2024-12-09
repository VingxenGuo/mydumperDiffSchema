/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `agent_access_game_3d` (
  `StatisDate` date NOT NULL,
  `ChannelID` int(11) NOT NULL,
  `GameID` int(11) NOT NULL,
  `WinGold` bigint(20) DEFAULT '0' COMMENT '赢钱',
  `LostGold` bigint(20) DEFAULT '0' COMMENT '输钱',
  `CellScore` bigint(20) DEFAULT '0' COMMENT '有效投注',
  `Revenue` bigint(20) DEFAULT '0' COMMENT '抽水',
  `WinNum` int(11) DEFAULT '0' COMMENT '赢钱局数',
  `LostNum` int(11) DEFAULT '0' COMMENT '输钱局数',
  `ActiveUsers` int(11) DEFAULT '0',
  `DayNewBetUsers` int(11) DEFAULT NULL,
  `currency` varchar(20) NOT NULL COMMENT '币种',
  `exchangeRate` decimal(20,5) DEFAULT NULL COMMENT '汇率',
  PRIMARY KEY (`StatisDate`,`ChannelID`,`GameID`,`currency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
