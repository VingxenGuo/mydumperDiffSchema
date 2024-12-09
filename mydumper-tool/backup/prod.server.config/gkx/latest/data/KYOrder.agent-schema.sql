/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `agent` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `playersHistoryId` bigint(20) DEFAULT NULL COMMENT 'wallet.players_history.id',
  `agentId` int(11) NOT NULL COMMENT 'KYDB_NEW.Sys_ProxyAccount.ChannelID',
  `type` tinyint(1) NOT NULL COMMENT '0後台上分/1後台下分',
  `status` tinyint(1) NOT NULL COMMENT '0成功/1失敗',
  `addScore` bigint(20) NOT NULL,
  `newScore` bigint(20) NOT NULL,
  `accountingForOrder` decimal(11,2) DEFAULT NULL,
  `createUser` varchar(50) NOT NULL,
  `ip` varchar(50) NOT NULL,
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_agentId` (`agentId`) USING BTREE,
  KEY `idx_type_status` (`playersHistoryId`,`agentId`,`type`,`status`) USING BTREE,
  KEY `idx_date_time` (`agentId`,`type`,`status`,`createTime`) USING BTREE,
  KEY `idx_playerHistoryId` (`playersHistoryId`) USING BTREE,
  KEY `idx_createTime` (`createTime`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4;
