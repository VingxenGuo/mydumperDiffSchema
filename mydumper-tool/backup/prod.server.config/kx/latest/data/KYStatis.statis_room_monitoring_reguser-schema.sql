/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_room_monitoring_reguser` (
  `createdate` date DEFAULT NULL COMMENT '时间',
  `roomId` int(11) DEFAULT '0' COMMENT '房间ID',
  `validBet` bigint(20) DEFAULT NULL COMMENT '玩家总有效投注',
  `revenue` bigint(20) DEFAULT '0' COMMENT '玩家总抽水',
  `currency` varchar(50) NOT NULL COMMENT '币别',
  `exchangeRate` decimal(20,5) DEFAULT NULL COMMENT '汇率',
  `profit` bigint(20) DEFAULT '0' COMMENT '玩家总输赢',
  `avgOnline` double DEFAULT '0' COMMENT '玩家平均在线',
  `maxOnline` double DEFAULT '0' COMMENT '玩家最高在线',
  `logCount` bigint(20) DEFAULT '0' COMMENT '玩家登录数量',
  `activeCount` bigint(20) DEFAULT '0' COMMENT '玩家活跃数量',
  `gameNum` bigint(20) DEFAULT '0' COMMENT '玩家总局数',
  `singleTime` double DEFAULT '0' COMMENT '玩家单局时长',
  `robotProfit` bigint(20) DEFAULT '0' COMMENT '普通机器人盈利',
  `killRobotProfit` bigint(20) DEFAULT '0' COMMENT '追杀机器人盈利',
  `revRobotProfit` bigint(20) DEFAULT '0' COMMENT '放水机器人盈利',
  `dayKillGold` bigint(20) DEFAULT '0',
  `dayDiveGold` bigint(20) DEFAULT '0',
  `gameTime` bigint(20) DEFAULT '0' COMMENT '总时长',
  `killGameNum` bigint(20) DEFAULT '0',
  `diveGameNum` bigint(20) DEFAULT '0',
  `normalValidbet` bigint(20) DEFAULT NULL,
  `gameId` int(11) DEFAULT '0',
  UNIQUE KEY `index_createdate_roomId_currency` (`createdate`,`roomId`,`gameId`,`currency`) USING BTREE,
  KEY `index_createdate` (`createdate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
