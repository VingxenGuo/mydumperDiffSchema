/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `abSettingGameInfo` (
  `serverID` tinyint(3) unsigned NOT NULL,
  `gameID` mediumint(8) unsigned NOT NULL,
  `gameState` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`serverID`,`gameID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
