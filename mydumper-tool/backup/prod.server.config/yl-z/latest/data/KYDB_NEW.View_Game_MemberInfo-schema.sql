/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE IF NOT EXISTS `View_Game_MemberInfo`(
`MemberID` int,
`account` int,
`ChannelID` int,
`mstatus` int,
`mark` int,
`lastlogintime` int,
`CreateTime` int,
`lineCode` int
) ENGINE=MEMORY;
