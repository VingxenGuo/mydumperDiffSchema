/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `eventReceiveLog` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `eventId` int(11) NOT NULL,
  `agentId` int(11) NOT NULL,
  `account` varchar(50) NOT NULL,
  `linecode` varchar(50) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `dayValidBet` bigint(20) NOT NULL,
  `rewardLevel` tinyint(4) NOT NULL,
  `rewardAmount` bigint(20) unsigned NOT NULL,
  `totalAmount` bigint(20) NOT NULL,
  `part` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `createTime` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `eventId_agentId_account_linecode` (`eventId`,`agentId`,`account`,`linecode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
