/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `finance_agent_level_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `StatisDate` varchar(255) DEFAULT NULL,
  `ChannelID` int(11) DEFAULT NULL,
  `LevelID` int(11) DEFAULT NULL,
  `AccountingFor` decimal(18,2) DEFAULT NULL,
  `LowerLimit` bigint(20) DEFAULT NULL,
  `TopLimit` bigint(20) DEFAULT NULL,
  `CreatPerson` varchar(50) DEFAULT NULL,
  `CreateTime` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;
