/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `6` (
  `StatisDate` text,
  `Account` text,
  `ChannelID` int(11) DEFAULT NULL,
  `LineCode` text,
  `AllBet` int(11) DEFAULT NULL,
  `CellScore` int(11) DEFAULT NULL,
  `WinGold` int(11) DEFAULT NULL,
  `LostGold` int(11) DEFAULT NULL,
  `Revenue` int(11) DEFAULT NULL,
  `WinNum` int(11) DEFAULT NULL,
  `LostNum` int(11) DEFAULT NULL,
  `currency` text,
  `exchangeRate` double DEFAULT NULL,
  `CreateTime` text,
  `UpdateTime` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
