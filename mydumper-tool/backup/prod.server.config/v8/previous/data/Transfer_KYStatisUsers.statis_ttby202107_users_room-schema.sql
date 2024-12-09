/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_ttby202107_users_room` (
  `StatisDate` date NOT NULL,
  `Account` varchar(100) NOT NULL,
  `ChannelID` int(11) DEFAULT NULL,
  `ServerID` int(11) NOT NULL DEFAULT '0',
  `CellScore` bigint(20) DEFAULT '0' COMMENT '有效投注',
  `WinGold` bigint(20) DEFAULT '0' COMMENT '赢钱',
  `LostGold` bigint(20) DEFAULT '0' COMMENT '输钱',
  `Revenue` bigint(20) DEFAULT '0' COMMENT '抽水',
  `WinNum` int(11) DEFAULT '0' COMMENT '赢钱局数(包含和局)',
  `LostNum` int(11) DEFAULT '0' COMMENT '输钱局数',
  `isNew` int(11) DEFAULT '0' COMMENT '是否是新注册0老,1新注册',
  `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`StatisDate`,`Account`,`ServerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
