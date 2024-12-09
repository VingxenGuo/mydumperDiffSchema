/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_record_game_month_reguser` (
  `StatisDate` varchar(7) NOT NULL COMMENT '统计月份',
  `GameID` int(11) NOT NULL DEFAULT '0' COMMENT '游戏ID',
  `WinGold` bigint(20) DEFAULT '0' COMMENT '赢钱金额',
  `LostGold` bigint(20) DEFAULT '0' COMMENT '输钱金额',
  `CellScore` bigint(20) DEFAULT '0' COMMENT '有效投注',
  `Revenue` bigint(20) DEFAULT '0' COMMENT '抽水',
  `WinNum` int(11) DEFAULT '0' COMMENT '赢钱局数',
  `LostNum` int(11) DEFAULT '0' COMMENT '输钱局数',
  `ActiveUsers` int(11) DEFAULT '0' COMMENT '投注人数',
  PRIMARY KEY (`StatisDate`,`GameID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
