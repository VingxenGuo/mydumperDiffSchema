/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `account_blacklist` (
  `Account` varchar(100) NOT NULL,
  `ChannelID` int(11) NOT NULL DEFAULT '0',
  `KillRoomRate` float NOT NULL,
  `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ConfigID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Account`,`ChannelID`),
  KEY `index_ChannelID` (`ChannelID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
