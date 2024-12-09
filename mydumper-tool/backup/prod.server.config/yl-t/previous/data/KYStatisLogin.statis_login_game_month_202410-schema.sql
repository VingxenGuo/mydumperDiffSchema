/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_login_game_month_202410` (
  `ChannelID` int(10) NOT NULL,
  `GameID` int(10) NOT NULL,
  `Accounts` varchar(200) DEFAULT NULL,
  UNIQUE KEY `index_StatisDate_ChannelID_GameId_LoginCount` (`ChannelID`,`GameID`,`Accounts`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
