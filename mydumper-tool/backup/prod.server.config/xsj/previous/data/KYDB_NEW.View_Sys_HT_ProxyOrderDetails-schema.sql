/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE IF NOT EXISTS `View_Sys_HT_ProxyOrderDetails`(
`OrderID` int,
`UID` int,
`PChannelName` int,
`ChannelID` int,
`ChannelName` int,
`OrderTime` int,
`OrderType` int,
`CurScore` int,
`AddScore` int,
`NewScore` int,
`OrderIP` int,
`CreateUser` int,
`OrderObject` int
) ENGINE=MEMORY;
