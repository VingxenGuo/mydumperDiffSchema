/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_record_agent_game` (
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
  `DayNewBetUsers` int(11) DEFAULT '0' COMMENT '当日有效注册并且投注人数',
  `currency` varchar(20) NOT NULL COMMENT '幣別',
  `exchangeRate` decimal(20,5) NOT NULL COMMENT '汇率',
  PRIMARY KEY (`StatisDate`,`ChannelID`,`GameID`,`currency`) USING BTREE,
  KEY `IDX_currency_gameId_StatisDate` (`currency`,`GameID`,`StatisDate`) USING BTREE,
  KEY `IDX_ChannelID_StatisDate_Currency_GameID` (`ChannelID`,`StatisDate`,`currency`,`GameID`) USING BTREE COMMENT '代理點數統計'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
/*!50100 PARTITION BY RANGE ( TO_DAYS(`StatisDate`))
(PARTITION p_202406 VALUES LESS THAN (739403) ENGINE = InnoDB,
 PARTITION p_202407 VALUES LESS THAN (739433) ENGINE = InnoDB,
 PARTITION p_202408 VALUES LESS THAN (739464) ENGINE = InnoDB,
 PARTITION p_202409 VALUES LESS THAN (739495) ENGINE = InnoDB,
 PARTITION p_202410 VALUES LESS THAN (739525) ENGINE = InnoDB,
 PARTITION p_202411 VALUES LESS THAN (739556) ENGINE = InnoDB,
 PARTITION p_202412 VALUES LESS THAN (739586) ENGINE = InnoDB,
 PARTITION p_202501 VALUES LESS THAN (739617) ENGINE = InnoDB,
 PARTITION p_202502 VALUES LESS THAN (739648) ENGINE = InnoDB) */;
