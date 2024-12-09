/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_KillRate_bk` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ChannelIDLinecode` varchar(50) DEFAULT NULL,
  `KillRate` decimal(20,5) DEFAULT NULL,
  `Type` tinyint(3) unsigned NOT NULL COMMENT '0: agentId, 1: linecode, 2: gameId, 3: roomId',
  `gameRoomId` mediumint(8) unsigned DEFAULT NULL COMMENT '遊戲或房間編號',
  `CreateUser` varchar(50) DEFAULT NULL,
  `UpdateUser` varchar(50) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `UpdateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
