/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `sys_killRate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agentId` int(11) NOT NULL COMMENT '代理id',
  `lineCode` varchar(50) DEFAULT NULL COMMENT 'lineCode',
  `gameId` mediumint(8) unsigned DEFAULT NULL COMMENT '游戏编号',
  `roomId` mediumint(8) unsigned DEFAULT NULL COMMENT '房间编号',
  `killRate` decimal(20,5) DEFAULT NULL COMMENT '盈利率',
  `ptk` decimal(20,6) DEFAULT NULL,
  `newPtk` decimal(20,6) DEFAULT NULL,
  `type` tinyint(3) unsigned NOT NULL COMMENT '0: agentId, 1: lineCode, 2: gameId, 3: roomId',
  `createUser` varchar(50) NOT NULL COMMENT '创建人',
  `createTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateUser` varchar(50) NOT NULL COMMENT '修改人',
  `updateTime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_agentId_lineCode_gameId_roomId` (`agentId`,`lineCode`,`gameId`,`roomId`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
