/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_room_monitoring_reguser` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `createdate` date DEFAULT NULL COMMENT '时间',
  `gameId` int(11) DEFAULT '0',
  `roomId` int(11) DEFAULT '0' COMMENT '房间ID',
  `validBet` bigint(20) DEFAULT NULL COMMENT '玩家总有效投注',
  `revenue` bigint(20) DEFAULT '0' COMMENT '玩家总抽水',
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_createdate_roomId` (`createdate`,`roomId`,`gameId`) USING BTREE,
  KEY `index_createdate` (`createdate`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
