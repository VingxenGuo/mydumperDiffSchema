/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `clear_money_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agentId` int(11) NOT NULL COMMENT '代理id',
  `memberAccount` varchar(200) DEFAULT NULL,
  `gameId` int(11) DEFAULT NULL,
  `orderId` varchar(190) NOT NULL,
  `gameUserNo` varchar(190) DEFAULT NULL,
  `currency` varchar(20) NOT NULL,
  `money` bigint(11) NOT NULL,
  `walletType` int(11) NOT NULL,
  `time` datetime DEFAULT NULL,
  `createDate` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `action` varchar(50) DEFAULT NULL,
  `createUser` varchar(100) NOT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `type` tinyint(1) DEFAULT NULL COMMENT '0: 派獎補發 1:取消下注重送',
  PRIMARY KEY (`id`),
  KEY `idx_account` (`memberAccount`),
  KEY `idx_account_createDate` (`memberAccount`,`createDate`) USING BTREE,
  KEY `idx_createDate` (`createDate`) USING BTREE,
  KEY `idx_gameUserNo` (`gameUserNo`) USING BTREE,
  KEY `idx_walletType` (`walletType`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE,
  KEY `idx_agentId` (`agentId`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
