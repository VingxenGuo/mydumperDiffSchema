/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_quick_game` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(190) DEFAULT NULL COMMENT '玩家账号',
  `agent` int(11) DEFAULT NULL COMMENT '代理编号',
  `gameId` int(11) DEFAULT NULL COMMENT '游戏id',
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_createdate_gameid` (`createdate`,`gameId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
