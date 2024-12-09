/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `gameGroupSort` (
  `infoId` int(10) unsigned NOT NULL,
  `lang` tinyint(1) unsigned NOT NULL,
  `gameId` int(10) unsigned NOT NULL,
  `sort` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`infoId`,`lang`,`gameId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
