/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_check_login` (
  `time` datetime NOT NULL,
  `agentId` int(11) unsigned NOT NULL,
  `allCount` int(10) unsigned NOT NULL,
  `loginCount` int(10) unsigned NOT NULL,
  PRIMARY KEY (`agentId`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
