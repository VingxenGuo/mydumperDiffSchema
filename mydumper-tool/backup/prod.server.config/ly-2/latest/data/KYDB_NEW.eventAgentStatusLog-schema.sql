/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `eventAgentStatusLog` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `eventId` int(10) unsigned NOT NULL,
  `agentId` int(10) unsigned NOT NULL,
  `status` tinyint(3) unsigned NOT NULL,
  `createTime` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `eventId_agentId` (`eventId`,`agentId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
