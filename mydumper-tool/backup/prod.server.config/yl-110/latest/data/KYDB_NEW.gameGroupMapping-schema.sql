/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `gameGroupMapping` (
  `agentId` int(10) unsigned NOT NULL COMMENT '對應 agent 的 id',
  `infoId` int(10) unsigned NOT NULL COMMENT '對應 gameGroupInfo 的 id',
  PRIMARY KEY (`agentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
