/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_game_daily` (
  `statisDate` date NOT NULL,
  `gameId` int(20) NOT NULL,
  `currency` varchar(20) NOT NULL COMMENT '幣別',
  `exchangeRate` decimal(20,5) DEFAULT NULL COMMENT '汇率',
  `dayProfit` bigint(30) DEFAULT NULL COMMENT '赢钱+输钱',
  `dayValidBet` bigint(30) DEFAULT NULL COMMENT '每日有效投注',
  `dayDeductGold` bigint(30) DEFAULT NULL COMMENT '每日抽水',
  `dayBetGames` int(20) DEFAULT NULL COMMENT '每日总游戏人数',
  `dayNewBetUsers` int(20) DEFAULT NULL COMMENT '当日有效注册并且投注人数',
  `gameNum` int(20) DEFAULT NULL COMMENT '每日总游戏局数',
  PRIMARY KEY (`statisDate`,`gameId`,`currency`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
