/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_linecode_monitoring` (
  `StatisDate` date NOT NULL,
  `ChannelID` int(11) NOT NULL,
  `LineCode` varchar(100) NOT NULL,
  `DWinGold` bigint(20) DEFAULT '0' COMMENT '天赢钱',
  `DLostGold` bigint(20) DEFAULT '0' COMMENT '天输钱',
  `DCellScore` bigint(20) DEFAULT '0' COMMENT '天有效投注',
  `DRevenue` bigint(20) DEFAULT '0' COMMENT '天抽水',
  `DWinNum` int(11) DEFAULT '0' COMMENT '天赢钱局数',
  `DLostNum` int(11) DEFAULT '0' COMMENT '天输钱局数',
  `DActiveUsers` int(11) DEFAULT '0' COMMENT '天活跃',
  `MWinGold` bigint(20) DEFAULT '0' COMMENT '月赢钱',
  `MLostGold` bigint(20) DEFAULT '0' COMMENT '月输钱',
  `MCellScore` bigint(20) DEFAULT '0' COMMENT '月有效投注',
  `MRevenue` bigint(20) DEFAULT '0' COMMENT '月抽水',
  `MWinNum` int(11) DEFAULT '0' COMMENT '月赢钱局数',
  `MLostNum` int(11) DEFAULT '0' COMMENT '月输钱局数',
  `MActiveUsers` int(11) DEFAULT '0' COMMENT '月活跃',
  `HWinGold` bigint(20) DEFAULT '0' COMMENT '历史赢钱',
  `HLostGold` bigint(20) DEFAULT '0' COMMENT '历史输钱',
  `HCellScore` bigint(20) DEFAULT '0' COMMENT '历史有效投注',
  `HRevenue` bigint(20) DEFAULT '0' COMMENT '历史抽水',
  `HWinNum` int(11) DEFAULT '0' COMMENT '历史赢钱局数',
  `HLostNum` int(11) DEFAULT '0' COMMENT '历史输钱局数',
  `HActiveUsers` int(11) DEFAULT '0' COMMENT '历史活跃',
  `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`StatisDate`,`ChannelID`,`LineCode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;
