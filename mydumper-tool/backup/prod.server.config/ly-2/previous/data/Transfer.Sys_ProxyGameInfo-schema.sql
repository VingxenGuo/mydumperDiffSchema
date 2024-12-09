/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_ProxyGameInfo` (
  `GameID` int(11) NOT NULL,
  `ChannelID` int(11) NOT NULL,
  `GameOrderBy` int(11) DEFAULT NULL,
  `GameStatus` int(11) DEFAULT NULL,
  `dlpower` int(11) DEFAULT '1' COMMENT '代理遊戲設置權限 關閉 = 0 開啟 = 1',
  `ShowLabel` int(11) DEFAULT NULL,
  `OutLink` varchar(200) DEFAULT NULL,
  `KillRate` float DEFAULT NULL,
  `gamegroup` varchar(50) DEFAULT '1' COMMENT '游戏分组',
  `lasteditdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `mark` varchar(255) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`GameID`,`ChannelID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
