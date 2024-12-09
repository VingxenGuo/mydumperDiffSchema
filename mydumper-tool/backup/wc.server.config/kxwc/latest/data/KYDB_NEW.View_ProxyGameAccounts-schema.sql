/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE IF NOT EXISTS `View_ProxyGameAccounts`(
`GameID` int,
`ChannelID` int,
`GameOrderBy` int,
`GameStatus` int,
`ShowLabel` int,
`OutLink` int,
`GameName` int,
`GameURL` int,
`Accounts` int,
`walletType` int,
`category` int
) ENGINE=MEMORY;
