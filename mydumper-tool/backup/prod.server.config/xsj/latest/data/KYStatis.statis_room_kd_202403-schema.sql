/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_room_kd_202403` (
  `StatisDate` date NOT NULL COMMENT '统计日期',
  `Type` tinyint(2) NOT NULL COMMENT '1新玩家 2老玩家',
  `MatchType` tinyint(2) NOT NULL COMMENT '追放类型 4追杀 5放水',
  `GameType` varchar(64) NOT NULL COMMENT '游戏',
  `RoomType` int(11) NOT NULL COMMENT '房间',
  `KDValidBet` varchar(255) DEFAULT NULL COMMENT '追放玩家投注',
  `KDWin` varchar(255) DEFAULT NULL COMMENT '追放金额',
  `currency` varchar(20) NOT NULL COMMENT '幣別',
  `exchangeRate` decimal(20,5) NOT NULL COMMENT '汇率',
  `KDGames` int(11) DEFAULT NULL COMMENT '追放局数',
  `KDUsers` int(11) DEFAULT NULL COMMENT '追放人数(不分币别)',
  `KDvalue` varchar(172) NOT NULL COMMENT 'KDvalue',
  `TotalUsers_userType` int(11) DEFAULT NULL COMMENT '房间总老/新玩家投注人数(不分币别)',
  `TotalUsers` int(11) DEFAULT NULL COMMENT '房间总投注人数(不分币别)',
  `CreateDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`StatisDate`,`Type`,`MatchType`,`GameType`,`RoomType`,`KDvalue`,`currency`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
