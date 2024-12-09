/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `player` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `playersHistoryId` bigint(20) DEFAULT NULL,
  `agentId` int(11) NOT NULL,
  `account` varchar(190) NOT NULL COMMENT '玩家帐号',
  `type` tinyint(1) NOT NULL COMMENT '0後台上分/1後台下分',
  `status` tinyint(1) NOT NULL COMMENT '0成功/1失敗',
  `addScore` bigint(20) NOT NULL,
  `newScore` bigint(20) NOT NULL,
  `currency` varchar(40) NOT NULL COMMENT '币别',
  `ip` varchar(50) NOT NULL,
  `createUser` varchar(50) NOT NULL,
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_agentId` (`agentId`) USING BTREE,
  KEY `idx_datetime` (`agentId`,`type`,`status`,`createTime`) USING BTREE,
  KEY `idx_playerHistoryId` (`playersHistoryId`) USING BTREE,
  KEY `idx_createTime` (`createTime`) USING BTREE,
  KEY `idx_type_status` (`agentId`,`type`,`status`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
