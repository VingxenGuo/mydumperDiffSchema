/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `player_dayrecord` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dayFTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `createtime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `account` varchar(190) DEFAULT NULL COMMENT '玩家账号',
  `agent` int(11) DEFAULT NULL COMMENT '代理编号',
  `lineCode` varchar(100) DEFAULT NULL COMMENT 'lineCode',
  `gameId` int(11) DEFAULT NULL COMMENT '游戏id',
  `totalGames` bigint(20) DEFAULT NULL,
  `validBet` bigint(20) DEFAULT NULL,
  `winGames` bigint(20) DEFAULT NULL,
  `winGold` bigint(20) DEFAULT NULL,
  `lostGames` bigint(20) DEFAULT NULL,
  `lostGold` bigint(20) DEFAULT NULL,
  `killGold` bigint(20) DEFAULT NULL,
  `deductGold` bigint(20) DEFAULT NULL,
  `dayTotalGames` bigint(20) DEFAULT NULL,
  `dayValidBet` bigint(20) DEFAULT NULL,
  `dayWinGames` bigint(20) DEFAULT NULL,
  `dayWinGold` bigint(20) DEFAULT NULL,
  `dayLostGames` bigint(20) DEFAULT NULL,
  `dayLostGold` bigint(20) DEFAULT NULL,
  `dayKillGold` bigint(20) DEFAULT NULL,
  `dayDeductGold` bigint(20) DEFAULT NULL,
  `dayDiveGold` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_gameId_account_dayFTime` (`gameId`,`account`,`dayFTime`) USING BTREE,
  KEY `index_dayFTime_agent_linecode` (`dayFTime`,`agent`,`lineCode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
