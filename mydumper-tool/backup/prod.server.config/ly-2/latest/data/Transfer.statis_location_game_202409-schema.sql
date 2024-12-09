/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_location_game_202409` (
  `StatisDate` date NOT NULL COMMENT '统计日期',
  `Location` varchar(190) DEFAULT NULL,
  `ServerID` int(11) NOT NULL,
  `BetUsers` int(11) NOT NULL DEFAULT '0' COMMENT '总投注人数',
  `GameNum` bigint(20) NOT NULL DEFAULT '0' COMMENT '总局数',
  KEY `index_statisdate` (`StatisDate`) USING BTREE,
  KEY `index_statisdate_location` (`StatisDate`,`Location`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;
