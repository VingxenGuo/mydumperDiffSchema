/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_agent_hall` (
  `statistics_date` date NOT NULL,
  `channelid` int(11) NOT NULL,
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`statistics_date`,`channelid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
